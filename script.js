// Declare variables for getting the xml file for the XSL transformation (folio_xml) and to load the image in IIIF on the page in question (number).
let tei = document.getElementById("folio");
let tei_xml = tei.innerHTML;
let extension = ".xml";
let folio_xml = tei_xml.concat(extension);
let page = document.getElementById("page");
let pageN = page.innerHTML;
let number = Number(pageN);

// Loading the IIIF manifest
var mirador = Mirador.viewer({
  "id": "my-mirador",
  "manifests": {
    "https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json": {
      provider: "Bodleian Library, University of Oxford"
    }
  },
  "window": {
    allowClose: false,
    allowWindowSideBar: true,
    allowTopMenuButton: false,
    allowMaximize: false,
    hideWindowTitle: true,
    panels: {
      info: false,
      attribution: false,
      canvas: true,
      annotations: false,
      search: false,
      layers: false,
    }
  },
  "workspaceControlPanel": {
    enabled: false,
  },
  "windows": [
    {
      loadedManifest: "https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json",
      canvasIndex: number,
      thumbnailNavigationPosition: 'off'
    }
  ]
});


// function to transform the text encoded in TEI with the xsl stylesheet "Frankenstein_text.xsl", this will apply the templates and output the text in the html <div id="text">
function documentLoader() {

    Promise.all([
      fetch(folio_xml).then(response => response.text()),
      fetch("Frankenstein_text.xsl").then(response => response.text())
    ])
    .then(function ([xmlString, xslString]) {
      var parser = new DOMParser();
      var xml_doc = parser.parseFromString(xmlString, "text/xml");
      var xsl_doc = parser.parseFromString(xslString, "text/xml");

      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl_doc);
      var resultDocument = xsltProcessor.transformToFragment(xml_doc, document);

      var criticalElement = document.getElementById("text");
      criticalElement.innerHTML = ''; // Clear existing content
      criticalElement.appendChild(resultDocument);
    })
    .catch(function (error) {
      console.error("Error loading documents:", error);
    });
  }
  
// function to transform the metadate encoded in teiHeader with the xsl stylesheet "Frankenstein_meta.xsl", this will apply the templates and output the text in the html <div id="stats">
  function statsLoader() {

    Promise.all([
      fetch(folio_xml).then(response => response.text()),
      fetch("Frankenstein_meta.xsl").then(response => response.text())
    ])
    .then(function ([xmlString, xslString]) {
      var parser = new DOMParser();
      var xml_doc = parser.parseFromString(xmlString, "text/xml");
      var xsl_doc = parser.parseFromString(xslString, "text/xml");

      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl_doc);
      var resultDocument = xsltProcessor.transformToFragment(xml_doc, document);

      var criticalElement = document.getElementById("stats");
      criticalElement.innerHTML = ''; // Clear existing content
      criticalElement.appendChild(resultDocument);
    })
    .catch(function (error) {
      console.error("Error loading documents:", error);
    });
  }

  // Initial document load
  documentLoader();
  statsLoader();
  // Event listener for sel1 change
  function selectHand(event) {
  var visible_mary = document.getElementsByClassName('hand-MWS');
  var visible_percy = document.getElementsByClassName('hand-PBS');
  // Convert the HTMLCollection to an array for forEach compatibility
  var MaryArray = Array.from(visible_mary);
  var PercyArray = Array.from(visible_percy);
  
  if (event.target.value == 'both') {
    //write an forEach() method that shows all the text written and modified by both hand (in black?). The forEach() method of Array instances executes a provided function once for each array element.
    MaryArray.forEach(el => {

      el.style.color = "black";
    });
    PercyArray.forEach(el => {

      el.style.color = "black";
    });

  } else if (event.target.value == 'Mary') {
    //write an forEach() method that shows all the text written and modified by Mary in a different color (or highlight it) and the text by Percy in black. 

    MaryArray.forEach(el => {

      el.style.color = "red";
    });
    PercyArray.forEach(el => {

      el.style.color = "black";
    });

  } else {
    //write an forEach() method that shows all the text written and modified by Percy in a different color (or highlight it) and the text by Mary in black.

    PercyArray.forEach(el => {

      el.style.color = "red";
    });
    MaryArray.forEach(el => {

      el.style.color = "black";
    });

  }
}
 
  
// write another function that will toggle the display of the deletions by clicking on a button
// EXTRA: write a function that will display the text as a reading text by clicking on a button or another dropdown list, meaning that all the deletions are removed and that the additions are shown inline (not in superscript)
function highlightHands() {
    // 抓取 Percy 的元素 (依賴 XSLT 產生的 class="hand-PBS")
    var percyElements = document.getElementsByClassName('hand-PBS');
    for (var i = 0; i < percyElements.length; i++) {
        percyElements[i].classList.toggle('highlight-pbs');
    }

    // 抓取 Mary 的元素 (依賴 XSLT 產生的 class="hand-MWS")
    var maryElements = document.getElementsByClassName('hand-MWS');
    for (var i = 0; i < maryElements.length; i++) {
        maryElements[i].classList.toggle('highlight-mws');
    }
}
function toggleDeletions() {
    // 假設你的刪除標籤是 <del>，如果是 span class="del" 請自行修改
    var deletions = document.getElementsByTagName('del');

    for (var i = 0; i < deletions.length; i++) {
        // 如果目前是隱藏 (none)，就顯示 (inline)
        if (deletions[i].style.display === 'none') {
            deletions[i].style.display = 'inline';
        } else {
            // 否則就隱藏
            deletions[i].style.display = 'none';
        }
    }
}
function toggleReadingText() {
    // 1. 處理刪除內容：強制加上 'hide-content' class 來隱藏
    var deletions = document.getElementsByTagName('del');
    for (var i = 0; i < deletions.length; i++) {
        // 使用 toggle 的第二個參數：true=強制加入, false=強制移除
        // 這裡我們簡單做成切換開關，假設使用者是在「正常模式」與「閱讀模式」間切換
        deletions[i].classList.toggle('hide-content');
    }

    // 2. 處理添加內容：讓它們變回正常行內文字
    var additions = document.getElementsByTagName('add');
    for (var i = 0; i < additions.length; i++) {
        additions[i].classList.toggle('reading-mode-inline');
    }
}

