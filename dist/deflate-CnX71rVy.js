import { i as inflate_1 } from "./pako.esm-kdyKjGUN.js";
import { B as BaseDecoder } from "./basedecoder-DosmR3tB.js";
class DeflateDecoder extends BaseDecoder {
  decodeBlock(buffer) {
    return inflate_1(new Uint8Array(buffer)).buffer;
  }
}
export {
  DeflateDecoder as default
};
//# sourceMappingURL=deflate-CnX71rVy.js.map
