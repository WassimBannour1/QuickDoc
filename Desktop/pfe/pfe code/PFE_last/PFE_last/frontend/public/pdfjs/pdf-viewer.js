// Simple PDF.js viewer integration
const initPdfViewer = (pdfUrl, containerId) => {
  const container = document.getElementById(containerId);
  if (!container) {
    console.error('PDF container not found:', containerId);
    return;
  }

  // Show loading state
  container.innerHTML = '<div class="pdf-loading"><div class="spinner"></div><p>Chargement du document...</p></div>';
  
  // Load PDF.js script dynamically
  const script = document.createElement('script');
  script.src = 'https://cdn.jsdelivr.net/npm/pdfjs-dist@2.16.105/build/pdf.min.js';
  script.onload = () => {
    // Configure worker
    pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdn.jsdelivr.net/npm/pdfjs-dist@2.16.105/build/pdf.worker.min.js';
    
    // Load the PDF
    const loadingTask = pdfjsLib.getDocument(pdfUrl);
    loadingTask.promise.then(
      pdf => {
        console.log('PDF loaded successfully');
        container.innerHTML = ''; // Clear container
        
        // Create canvas for each page
        const renderPage = (pageNum) => {
          pdf.getPage(pageNum).then(page => {
            const scale = 1.5;
            const viewport = page.getViewport({ scale });
            
            // Prepare canvas
            const canvas = document.createElement('canvas');
            const context = canvas.getContext('2d');
            canvas.height = viewport.height;
            canvas.width = viewport.width;
            container.appendChild(canvas);
            
            // Render PDF page into canvas context
            const renderContext = {
              canvasContext: context,
              viewport: viewport
            };
            
            page.render(renderContext).promise.then(() => {
              if (pageNum < pdf.numPages) {
                renderPage(pageNum + 1);
              }
            });
          });
        };
        
        // Start rendering from first page
        renderPage(1);
      },
      error => {
        console.error('Error loading PDF:', error);
        container.innerHTML = `
          <div class="pdf-error">
            <i class="fas fa-exclamation-triangle"></i>
            <p>Impossible de charger le PDF. ${error.message || ''}</p>
            <div class="pdf-actions">
              <a href="${pdfUrl}" target="_blank" class="action-btn preview-btn">
                <i class="fas fa-external-link-alt"></i> Ouvrir dans un nouvel onglet
              </a>
            </div>
          </div>
        `;
      }
    );
  };
  
  script.onerror = () => {
    console.error('Failed to load PDF.js library');
    container.innerHTML = `
      <div class="pdf-error">
        <i class="fas fa-exclamation-triangle"></i>
        <p>Impossible de charger la bibliothèque d'affichage PDF.</p>
        <div class="pdf-actions">
          <a href="${pdfUrl}" target="_blank" class="action-btn preview-btn">
            <i class="fas fa-external-link-alt"></i> Ouvrir dans un nouvel onglet
          </a>
        </div>
      </div>
    `;
  };
  
  document.body.appendChild(script);
};

window.initPdfViewer = initPdfViewer;
