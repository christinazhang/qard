const firebase = require('firebase')
const config = {
    apiKey: "AIzaSyBsaKnEkZ9MfJzsh_6ajoypvccFFUvV5-I",
    projectId: "qard-25427",
    authDomain: "qard-25427.firebaseapp.com",
    databaseURL: "https://qard-25427.firebaseio.com",
    storageBucket: "qard-25427.appspot.com"
};
var database;

// returns array of json objects, each with card data
module.exports = async (userId = 'default', cardId = 'testCard') => {
    // initialize db
    if (!firebase.apps.length) {
        firebase.initializeApp(config);
    }
    database = firebase.firestore();


    return getUserCard(userId, cardId);
};

var getUserCard = function(userId, cardId) {
  var docRef = database.collection("users").doc(userId);
  return docRef.get().then(function(docSnapshot) {
    if (docSnapshot.exists) {
       return docSnapshot.data()["cards"].find(function(card) {
        return card["cardId"] == cardId;
      });
    } else {
      return userId + " doesn't exist";
    }
  })
}