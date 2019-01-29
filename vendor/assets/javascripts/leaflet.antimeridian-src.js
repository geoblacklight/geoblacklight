(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
	typeof define === 'function' && define.amd ? define(['exports'], factory) :
	(factory((global.L = global.L || {}, global.L.Wrapped = {})));
}(this, (function (exports) { 'use strict';

var version = "1.0.0+master.7986dc5";

/*
 * @namespace L.Wrapped
 * Utility functions to perform calculations not always supported by the
 * standard Javascript Math namespace.
 */

// @function sign(Number)
// Returns NaN for non-numbers, 0 for 0, -1 for negative numbers,
// 1 for positive numbers
function sign(x) {
	return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : 0 : NaN;
}

/*
 * @namespace L.Wrapped
 * Utility functions to calculate various shared aspects of mapping a line
 * accross the antimeridian.
 */

// @function calculateAntimeridianLat (latLngA: L.LatLng, latLngB: L.LatLng)
// Returns the calculated latitude where a line drawn between
// two Latitude/Longitude points will cross the antimeridian.
function calculateAntimeridianLat(latLngA, latLngB) {
	if (latLngA instanceof L.LatLng && latLngB instanceof L.LatLng) {
		// Ensure that the latitude A is less than latidue B. This will allow the
		// crossing point to be calculated based on the proportional similarity of
		// right triangles.

		// Locate which latitude is lower on the map. This will be the most
		// accute angle of the right triangle. If the lowest latitude is not latLngA
		// then swap the latlngs so it is.
		if (latLngA.lat > latLngB.lat) {
			var temp = latLngA;
			latLngA = latLngB;
			latLngB = temp;
		}

		// This gets the width of the distance between the two points
		// (The bottom of a large right triangle drawn between them)
		var A = 360 - Math.abs(latLngA.lng - latLngB.lng);
		// This gets the height of the of distance between the two points
		// (The vertical line of a large right triange drawn between them)
		var B = latLngB.lat - latLngA.lat;
		// This gets the bottom distance of a proportional triangle inside the large
		// trangle where the vertical line instead sits at the 180 mark.
		var a = Math.abs(180 - Math.abs(latLngA.lng));

		// Because triangle with identical angles must be proportional along the sides,
		// find the length of the vertical side of that inner triangle and then
		// add it to the lower point to predict the crossing point of the Antimeridian.
		return latLngA.lat + ((B * a) / A);
	} else {
		throw new Error('In order to calculate the Antimeridian latitude, two valid LatLngs are required.');
	}
}

// @function isCrossAntimeridian(latLngA: L.LatLng, latLngB: L.LatLng)
// Returns true if the line between the two points will cross either
// the prime meridian (Greenwich) or its antimeridian (International Date Line)
function isCrossMeridian(latLngA, latLngB) {
	if (latLngA instanceof L.LatLng && latLngB instanceof L.LatLng) {
		// Returns true if the signs are not the same.
		return sign(latLngA.lng) * sign(latLngB.lng) < 0;
	} else {
		throw new Error('In order to calculate whether two LatLngs cross a meridian, two valid LatLngs are required.');
	}
}


// @function pushLatLng(ring: L.Point[], projectedBounds: L.Bounds, latlng: L.LatLng, map: L.Map)
// Adds the latlng to the current ring as a layer point and expands the projected bounds.
function pushLatLng(ring, projectedBounds, latlng, map) {
	if (ring instanceof Array && projectedBounds instanceof L.Bounds && latlng instanceof L.LatLng && map instanceof L.Map) {
		ring.push(map.latLngToLayerPoint(latlng));
		projectedBounds.extend(ring[ring.length - 1]);
	} else {
		throw new Error('In order to push a LatLng into a ring, the ring point array, the LatLng, the projectedBounds, and the map must all be valid.');
	}
}

// @function isBreakRing(latLngA: L.LatLng, latLngB: L.LatLng)
// Determines when the ring should be broken and a new one started.
// This will return true if the distance is smaller when mapped across the Antimeridian.
function isBreakRing(latLngA, latLngB) {
	if (latLngA instanceof L.LatLng && latLngB instanceof L.LatLng) {
		return isCrossMeridian(latLngA, latLngB)  &&
		(360 - Math.abs(latLngA.lng) - Math.abs(latLngB.lng) < 180);

	} else {
		throw new Error('In order to calculate whether the ring created by two LatLngs should be broken, two valid LatLngs are required.');
	}
}

// @function breakRing(currentLat: L.LatLng, nextLat: L.LatLng, rings: L.Point[][],
//  projectedBounds: L.Bounds, map: L.Map)
// Breaks the existing ring along the anti-meridian.
// returns the starting latLng for the next ring.
function breakRing(currentLat, nextLat, rings, projectedBounds, map) {
	if (currentLat instanceof L.LatLng && nextLat instanceof L.LatLng && rings instanceof Array && projectedBounds instanceof L.Bounds && map instanceof L.Map) {
		var ring = rings[rings.length - 1];

		// Calculate two points for the anti-meridian crossing.
		var breakLat = calculateAntimeridianLat(currentLat, nextLat);
		var breakLatLngs = [new L.LatLng(breakLat, 180), new L.LatLng(breakLat, -180)];

		// Add in first anti-meridian latlng to this ring to finish it.
		// Positive if positive, negative if negative.
		if (sign(currentLat.lng) > 0) {
			pushLatLng(ring, projectedBounds, breakLatLngs.shift(), map);
		} else {
			pushLatLng(ring, projectedBounds, breakLatLngs.pop(), map);
		}

		// Return the second anti-meridian latlng
		return breakLatLngs.pop();
	} else {
		throw new Error('In order to break a ring, all the inputs must exist and be valid.');
	}
}

/*
 * @namespace L.Wrapped
 * A polyline that will automatically split and wrap around the Antimeridian (Internation Date Line).
 */
var Polyline = L.Polyline.extend({

	// recursively turns latlngs into a set of rings with projected coordinates
	// This is the entrypoint that is called from the overriden class to change
	// the rendering.
	_projectLatlngs: function (latlngs, result, projectedBounds) {
		var isMultiRing = latlngs[0] instanceof L.LatLng;

		if (isMultiRing) {
			this._createRings(latlngs, result, projectedBounds);
		} else {
			for (var i = 0; i < latlngs.length; i++) {
				this._projectLatlngs(latlngs[i], result, projectedBounds);
			}
		}
	},

	// Creates the rings used to render the latlngs.
	_createRings: function (latlngs, rings, projectedBounds) {
		var len = latlngs.length;
		rings.push([]);

		for (var i = 0; i < len; i++) {
			var compareLatLng = this._getCompareLatLng(i, len, latlngs);
			var currentLatLng = latlngs[i];

			pushLatLng(rings[rings.length - 1], projectedBounds, latlngs[i], this._map);

			// If the next point to check exists, then check to see if the
			// ring should be broken.
			if (compareLatLng && isBreakRing(compareLatLng, currentLatLng)) {
				var secondMeridianLatLng = breakRing(currentLatLng, compareLatLng,
					rings, projectedBounds, this._map);

				this._startNextRing(rings, projectedBounds, secondMeridianLatLng);
			}
		}
	},

	// returns the latlng to compare the current latlng to.
	_getCompareLatLng: function (i, len, latlngs) {
		return (i + 1 < len) ? latlngs[i + 1] : null;
	},

		// Starts a new ring and adds the second meridian point.
	_startNextRing: function (rings, projectedBounds, secondMeridianLatLng) {
		var ring = [];
		rings.push(ring);
		pushLatLng(ring, projectedBounds, secondMeridianLatLng, this._map);
	}
});

// @factory L.wrappedPolyline(latlngs: LatLng[], options?: Polyline options)
// Instantiates a polyline that will automatically split around the
// antimeridian (Internation Date Line) if that is a shorter path.
function wrappedPolyline(latlngs, options) {
	return new L.Wrapped.Polyline(latlngs, options);
}

/*
 * @namespace L.Wrapped
 * A polygon that will automatically split and wrap around the Antimeridian (Internation Date Line).
 */
var Polygon = L.Polygon.extend({

	// recursively turns latlngs into a set of rings with projected coordinates
	// This is the entrypoint that is called from the overriden class to change
	// the rendering.
	_projectLatlngs: function (latlngs, result, projectedBounds) {
		var isMultiRing = latlngs[0] instanceof L.LatLng;

		if (isMultiRing) {
			this._createRings(latlngs, result, projectedBounds);
		} else {
			for (var i = 0; i < latlngs.length; i++) {
				this._projectLatlngs(latlngs[i], result, projectedBounds);
			}
		}
	},

	// Creates the rings used to render the latlngs.
	_createRings: function (latlngs, rings, projectedBounds) {
		var len = latlngs.length;
		rings.push([]);

		for (var i = 0; i < len; i++) {
			// Because this is a polygon, there will always be a comparison latlng
			var compareLatLng = this._getCompareLatLng(i, len, latlngs);
			var currentLatLng = latlngs[i];

			pushLatLng(rings[rings.length - 1], projectedBounds, currentLatLng, this._map);

			// Check to see if the ring should be broken.
			if (isBreakRing(compareLatLng, currentLatLng)) {
				var secondMeridianLatLng = breakRing(currentLatLng, compareLatLng,
					rings, projectedBounds, this._map);

				this._startNextRing(rings, projectedBounds, secondMeridianLatLng, i === len - 1);
			}
		}

		// Join the last two rings if needed.
		this._checkConcaveRings(rings);
		this._joinLastRing(rings, latlngs);
	},

	// Starts a new ring if needed and adds the second meridian point to the
	// correct ring.
	_startNextRing: function (rings, projectedBounds, secondMeridianLatLng, isLastLatLng) {
		var ring;
		if (!isLastLatLng) {
			ring = [];
			rings.push(ring);
			pushLatLng(ring, projectedBounds, secondMeridianLatLng, this._map);
		} else {
			// If this is the last latlng, don't bother starting a new ring.
			// instead, join the last meridian point to the first point, to connect
			// the shape correctly.
			ring = rings[0];
			ring.unshift(this._map.latLngToLayerPoint(secondMeridianLatLng));
			projectedBounds.extend(ring[0]);
		}
	},

	// returns the latlng to compare the current latlng to.
	_getCompareLatLng: function (i, len, latlngs) {
		return (i + 1 < len) ? latlngs[i + 1] : latlngs[0];
	},

	// Joins the last ring to the first if they were accidentally disconnected by
	// crossing the anti-meridian
	_joinLastRing: function (rings, latlngs) {
		var firstRing = rings[0];
		var lastRing = rings[rings.length - 1];

		// If either the first or last latlng cross the meridian immediately, then
		// they will be drawn as a single line, not a polygon, since they will not be
		// connected to the last ring. Reconnect them.
		if (rings.length > 1 && (firstRing.length === 2 || lastRing.length === 2) &&
			 !isCrossMeridian(latlngs[0], latlngs[latlngs.length - 1])) {
			var len = lastRing.length;
			for (var i = 0; i < len; i++) {
				firstRing.unshift(lastRing.pop());
			}
			// Remove the empty ring.
			rings.pop();
		}
	},

	// Check for concave sections of the rings and join the rings if they are
	// concave
	_checkConcaveRings: function (rings) {
		var firstLatLng = this._map.layerPointToLatLng(rings[0][0]);

		for (var i = 0; i <= rings.length - 3; i++) {
			var middleLatLng = this._map.layerPointToLatLng(rings[i + 1][0]);
			var lastLatLng = this._map.layerPointToLatLng(rings[i + 2][0]);

			// If the meridian is crossed and then is crossed again
			// over the first polygon, the polygon is concave. Join the rings.
			if (isCrossMeridian(firstLatLng, middleLatLng) &&
			isCrossMeridian(middleLatLng, lastLatLng)) {
				var firstRing = rings[0];
				var lastRing = rings[i + 2];

				var newRing = firstRing.concat(lastRing);

				// Remove the joined polygon and then update the first polygon.
				rings.splice(i + 2, 1);
				rings.splice(0, 1, newRing);
			}
		}
	}
});

// @factory L.wrappedPolygon(latlngs: LatLng[], options?: Polygon options)
// Instantiates a polygon that will automatically split around the
// antimeridian (Internation Date Line) if that is a shorter path.
function wrappedPolygon(latlngs, options) {
	return new L.Wrapped.Polygon(latlngs, options);
}

exports.version = version;
exports.Polyline = Polyline;
exports.wrappedPolyline = wrappedPolyline;
exports.Polygon = Polygon;
exports.wrappedPolygon = wrappedPolygon;
exports.calculateAntimeridianLat = calculateAntimeridianLat;
exports.isCrossMeridian = isCrossMeridian;
exports.isBreakRing = isBreakRing;
exports.sign = sign;

})));
//# sourceMappingURL=leaflet.antimeridian-src.js.map
