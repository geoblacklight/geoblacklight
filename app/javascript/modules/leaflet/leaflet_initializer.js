import BookmarksMap from "./maps/bookmarks_map";
import HomepageMap from "./maps/homepage_map";
import ItemMap from "./maps/item_map";
import SearchResultsMap from "./maps/search_results_map";

export default class LeafletInitializer {
  run() {
    document
      .querySelectorAll('#leaflet-viewer[data-page="bookmarks"]')
      .forEach((element) => new BookmarksMap(element));
    document.querySelectorAll('#leaflet-viewer[data-page="home"]').forEach((element) => {
      new HomepageMap(element);
    });
    document.querySelectorAll('#leaflet-viewer[data-page="show"]').forEach((element) => {
      new ItemMap(element);
    });
    document.querySelectorAll('#leaflet-viewer[data-page="index"]').forEach((element) => {
      new SearchResultsMap(element);
    });
  }
}
