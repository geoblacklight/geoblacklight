import { CloverInitializer } from '@geoblacklight/frontend'

const initializer = new CloverInitializer();
document.addEventListener("turbo:load", initializer.run);
