async function shouldThrow(promise) {
    try {
        await promise;
       assert(true);
    }
    catch (err) {
      let error = JSON.stringify(err, Object.getOwnPropertyNames(err));
      console.log(error.substring(0,240));
      return;
    }
  assert(false, "The contract did not throw.");
  
  }
  
  module.exports = {
    shouldThrow,
  };