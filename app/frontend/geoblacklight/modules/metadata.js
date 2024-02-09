/* @TODO: Doesn't work. Modal loaded event isn't fired or isn't perceived
document.addEventListener('DOMContentLoaded', () => {
  const modal = document.getElementById('blacklight-modal');
  
  modal.addEventListener('loaded.blacklight.blacklight-modal', (e) => {
    e.target.querySelectorAll('.metadata-body').forEach((el) => {
      el.closest('.modal-content').classList.add('metadata-modal');
    });
    
    e.target.querySelectorAll('.pill-metadata').forEach((element, i) => {
      GeoBlacklight.metadataDownloadButton(element, i);
    });
  });

  modal.addEventListener('hidden.bs.modal', (e) => {
    e.target.querySelectorAll('.metadata-body').forEach((el) => {
      el.closest('.modal-content').classList.remove('metadata-modal');
    });
  });
});

// Works if ...
// 1. Run manually in console after modal is loaded, or 
// 2. Written directly into view partial
//
/* 
document.querySelectorAll('.pill-metadata').forEach((element, i) => {
  GeoBlacklight.metadataDownloadButton(element, i);
});
*/