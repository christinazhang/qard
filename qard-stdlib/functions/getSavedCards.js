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
module.exports = async (userId = 'defaults') => {
    // initialize db
    if (!firebase.apps.length) {
        firebase.initializeApp(config);
    }
    database = firebase.firestore();
    return getSavedCards(userId);
};


var getSavedCards = function(userId) {
    var docRef = database.collection("users").doc(userId);
    return docRef.get().then(function(docSnapshot) {
        if (docSnapshot.exists) {
            var savedCardPromises = [];
            var savedCards = docSnapshot.data()["savedCards"];
            var cardIds = [];
            for (i = 0; i < savedCards.length; i++) {
              var savedCard = savedCards[i];
              var savedUserId = savedCard["userId"];
              var savedCardId = savedCard["cardId"];
              cardIds[0] = savedCardId;
              var otherCardDocRef = database.collection("users").doc(savedUserId);
             savedCardPromises.push(otherCardDocRef.get())
              
            }
            return Promise.all(savedCardPromises).then(function(docSnapshots) {
                var allSavedCards = [];
                for (i = 0; i < docSnapshots.length; i++) {
                  var docSnapshot = docSnapshots[i];
                  var card = docSnapshot.data()["cards"].find(function(card) {
                    return card["cardId"] == cardIds[i];
                  });
                  if (card != null) {
                    allSavedCards.push(card);
                  }
                }
                return allSavedCards;
            });
        } else {
            return userId + " doesn't exist";
        }
    })
};