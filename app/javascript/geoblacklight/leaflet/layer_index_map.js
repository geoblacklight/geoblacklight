const indexMapInfoTemplate = (data) => `
  <div class="index-map-info">
    ${data.title
        ? `
      <div class="col-sm-12">
        <h3>${data.title}</h3>
      </div>`
        : ""
    }
    <div class="col-sm-12">
      ${data.thumbnailUrl
        ? `
        ${data.websiteUrl
            ? `
          <a href="${data.websiteUrl}">
            <img src="${data.thumbnailUrl}" class="img-responsive">
          </a>`
            : `
          <img src="${data.thumbnailUrl}">`
        }`
        : ""
    }
      <dl class="row dl-invert document-metadata">
        ${data.websiteUrl
        ? `
          <dt class="col-sm-3">Website:</dt>
          <dd class="col-sm-9"><a href="${data.websiteUrl}">${data.websiteUrl}</a></dd>`
        : ""
    }
        ${data.downloadUrl
        ? `
          <dt class="col-sm-3">Download:</dt>
          <dd class="col-sm-9"><a href="${data.downloadUrl}">${data.downloadUrl}</a></dd>`
        : ""
    }
        ${data.recordIdentifier
        ? `
          <dt class="col-sm-3">Record Identifier:</dt>
          <dd class="col-sm-9">${data.recordIdentifier}</dd>`
        : ""
    }
        ${data.label
        ? `
          <dt class="col-sm-3">Label:</dt>
          <dd class="col-sm-9">${data.label}</dd>`
        : ""
    }
        ${data.note
        ? `
          <dt class="col-sm-3">Note:</dt>
          <dd class="col-sm-9">${data.note}</dd>`
        : ""
    }
      </dl>
    </div>
  </div>`;
  
const indexMapDownloadTemplate = (data) =>
    data.downloadUrl
        ? `
  <li class="list-group-item download js-index-map-feature">
    <h3 class="card-subtitle">Selected feature</h3>
    <ul class="list-group list-group-flush list-group-nested">
      <li class="list-group-item download">
        <div class="download-link-container">
          <a class="btn btn-default download download-original" href="${data.downloadUrl
        }">
            ${data.label ? data.label : "Download"}
          </a>
        </div>
      </li>
    </ul>
  </li>
`
        : "";

const indexMapTemplate = (data) => {
    return new Promise((resolve) => {
        if (data.iiifUrl && !data.thumbnailUrl) {
            fetch(data.iiifUrl)
                .then((response) => response.json())
                .then((manifestResponse) => {
                    if (manifestResponse.thumbnail["@id"] !== null) {
                        data.thumbnailUrl = manifestResponse.thumbnail["@id"];
                    }
                    resolve(data); // Resolve the modified data
                })
                .catch(() => resolve(data)); // In case of error, resolve with original data
        } else {
            resolve(data); // Immediately resolve if no iiifUrl
        }
    });
};

export const availabilityStyle = (availability, leafletOptions) => {
    var style = availability || typeof availability === "undefined"
        ? leafletOptions.LAYERS.INDEX.DEFAULT
        : leafletOptions.LAYERS.INDEX.UNAVAILABLE;
    style['fillOpacity'] = leafletOptions.opacity || .65;
    style['opacity'] = leafletOptions.opacity || .65;
    return style
}

export const updateInformation = (properties) => {
    indexMapTemplate(properties).then((updatedProperties) => {
        const indexMapHtml = indexMapInfoTemplate(updatedProperties);
        document.querySelector(".viewer-information").innerHTML = indexMapHtml;

        const indexMapDownloadHtml =
            indexMapDownloadTemplate(updatedProperties);
        const downloadElement = document.querySelector(".js-download-list");

        if (Boolean(downloadElement)) {
            downloadElement.innerHTML += indexMapDownloadHtml; // Appends new download template
            downloadElement
                .querySelectorAll(".js-index-map-feature")
                .forEach((elem) => elem.remove());
        }
    });
};
