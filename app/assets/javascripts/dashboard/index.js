new Vue({
  el: '#dashboard',
  created: function() {
    this.loadOrderDetails();
  },
  methods: {
    loadOrderDetails() {
      axios.post('/dashboard/orders/load_detail', {}, {
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': window.token
        }
      }).then(res => {
        console.log(res);
      })
    }
  }
})
