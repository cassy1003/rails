new Vue({
  el: '#dashboard_items',
  data: {
    visibleModal: true,
    visibleSupplierWarning: false,
    loadingFromSupplier: false,
    title: '',
    supplier: '',
    colors: [],
    originalTitle: '',
    originalShopName: '',
    originalSizes: [],
    originalColors: [],
  },
  computed: {
    originalVariations() {
      if (this.originalSizes.length == 0 && this.originalColors.length == 0) return [];
      if (this.originalSizes.length == 0) return this.originalColors;
      if (this.originalColors.length == 0) return this.originalSizes;

      let variations = [];
      this.originalSizes.forEach(size => {
        this.originalColors.forEach(color => {
          variations.push([size, color]);
        })
      });
      return variations;
    },
    jaVariations() {
      if (this.originalSizes.length == 0 && this.originalColors.length == 0) return [];
      if (this.originalSizes.length == 0) return this.colors;
      if (this.originalColors.length == 0) return this.originalSizes;

      let variations = [];
      this.originalSizes.forEach(size => {
        this.colors.forEach(color => {
          variations.push([size + ' / ' + color]);
        })
      });
      return variations;
    },
  },
  methods: {
    loadFromSupplier() {
      this.loadingFromSupplier = true;
      this.visibleSupplierWarning = false;
      if (this.supplier.indexOf('http') != 0) {
        this.loadingFromSupplier = false;
        this.visibleSupplierWarning = true;
        return;
      }
      console.log(this.supplier);
      axios.post('/dashboard/items/load_supplier_data', {
        url: this.supplier
      }, {
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': window.token
        }
      }).then(res => {
        const data = res['data'];
        this.originalTitle = data['title'];
        this.originalShopName = data['shop'];
        this.originalSizes = data['size_list'];
        this.originalColors = data['color_list'];

        const glot = new Glottologist();
        glot.gTranslate(this.originalTitle, 'ja').then(r => {
          this.title = r;
        });

        glot.gTranslate(JSON.stringify(this.originalColors), 'ja').then(r => {
          this.colors = JSON.parse(r.replace(/、/g, ','));
        });

        this.loadingFromSupplier = false;
        this.visibleModal = false;
      })
    },
    hideModal() {
      this.visibleModal = false;
    }
  }
})
