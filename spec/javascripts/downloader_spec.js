import GeoBlackLightDownloader from '/app/javascript/geoblacklight/downloaders/downloader.js';

describe('GeoBlackLightDownloader', () => {
    let downloader;
    let mockElement;

    beforeEach(() => {

        mockElement = {
            addEventListener: jest.fn(),
            getAttribute: jest.fn().mockReturnValue('http://example.com'),
            disabled: false
        };
        document.querySelector = jest.fn().mockReturnValue(mockElement);
        document.createElement = jest.fn().mockReturnValue({
            style: { display: 'none' },
            className: '',
            appendChild: jest.fn(),
            innerHTML: ''
        });
        document.body.appendChild = jest.fn();
        downloader = new GeoBlackLightDownloader('#download-button', {});
    });

    it('initializes with given element and options', () => {
        expect(document.querySelector).toHaveBeenCalledWith('#download-button');
        expect(downloader.el).toEqual(mockElement);
    });

    it('adds click listener to element', () => {
        expect(mockElement.addEventListener).toHaveBeenCalledWith('click', expect.any(Function));
    });
});