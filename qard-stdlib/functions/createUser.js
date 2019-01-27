const firebase = require('firebase')
const config = {
    apiKey: "AIzaSyBsaKnEkZ9MfJzsh_6ajoypvccFFUvV5-I",
    projectId: "qard-25427",
    authDomain: "qard-25427.firebaseapp.com",
    databaseURL: "https://qard-25427.firebaseio.com",
    storageBucket: "qard-25427.appspot.com"
};
var database;

module.exports = async (userId = 'default') => {
    // initialize db
    if (!firebase.apps.length) {
        firebase.initializeApp(config);
    }
    database = firebase.firestore();


    return createUser(userId);
};

var createUser = function(userId) {
    var setPromise = database.collection("users").doc(userId).get()
      .then(function(docData) {
          if (docData.exists) {
              return "user already exists";
          } else {
              return database.collection("users").doc(userId).set({
                  cards: [],
                  savedCards: []
              });
          }
      });
    return setPromise.then(function() {
        return "added";
    })
}
