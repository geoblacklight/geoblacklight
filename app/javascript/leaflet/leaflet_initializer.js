import BookmarksMap from "./maps/bookmarks_map";
import HomepageMap from "./maps/homepage_map";
import ItemMap from "./maps/item_map";
import SearchResultsMap from "./maps/search_results_map";

export default class LeafletInitializer {
  run() {
    document
      .querySelectorAll('[data-map="bookmarks"]')
      .forEach((element) => new BookmarksMap(element));
    document.querySelectorAll('[data-map="home"]').forEach((element) => {
      new HomepageMap(element);
    });
    document.querySelectorAll('[data-map="item"]').forEach((element) => {
      new ItemMap(element);
    });
    document.querySelectorAll('[data-map="index"]').forEach((element) => {
      new SearchResultsMap(element);
    });
  }
}
