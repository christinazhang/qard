const firebase = require('firebase')
const config = {
    apiKey: "AIzaSyBsaKnEkZ9MfJzsh_6ajoypvccFFUvV5-I",
    projectId: "qard-25427",
    authDomain: "qard-25427.firebaseapp.com",
    databaseURL: "https://qard-25427.firebaseio.com",
    storageBucket: "qard-25427.appspot.com"
};
var database;

module.exports = async (userId = 'testUser', otherUserId = 'testUser', cardId = 'testCard') => {
    // initialize db
    if (!firebase.apps.length) {
        firebase.initializeApp(config);
    }
    database = firebase.firestore();

    return saveCard(userId, otherUserId, cardId);
};

var saveCard= function(userId, otherUserId, cardId) {
    var docRef = database.collection("users").doc(userId);
    return docRef.get()
      .then(function(docData) {
          if (docData.exists) {
              var cards = docData.data()["savedCards"];

              cards.push({
                  userId: otherUserId,
                  cardId: cardId
              });
              return docRef.update({
                  savedCards: cards
              }).then(function(response) {
                  return "added";
              });
          } else {
              return userId + " doesn't exist";
          }
      });
};
