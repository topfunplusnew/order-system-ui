//混入
export var mixin_printHTML = {
  data: function () {
    return {}
  },
  methods: {
    printHTML() {
      const printContent = document.getElementById('printBox').outerHTML;
      const newWindow = window.open('', '_blank');
      newWindow.document.write(`
    <html>
      <head>
        <style>
          @media print {
            @page {
              size: landscape; /* 设置横向打印 */
            }
          }
        </style>
      </head>
      <body>${printContent}</body>
    </html>
  `);
      newWindow.document.close();
      newWindow.print();
      newWindow.close();
    },
  }
}
