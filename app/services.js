// Utility services
jprServices.factory('Page', ['$rootScope', function($rootScope) {
  var defaultTitle = 'JPR';
  var title = defaultTitle;
  var currentLink = '';
  var errorMessages = [];
  var infoMessages = [];
  var flash = '';
  var flashQueue = [];
  var errorFlash = '';
  var errorFlashQueue = [];
  $rootScope.$on('$locationChangeSuccess', function(_, oldLocation, newLocation) {
    // Clear messages on refresh
    errorMessages.clear();
    infoMessages.clear();
    if (oldLocation != newLocation) {
      flash = flashQueue.shift() || "";
      errorFlash = errorFlashQueue.shift() || "";
    }    
  });

  return {
    title: function() {
      return title;
    },
    clearTitle: function() {
      title = defaultTitle;
    },
    clearCurrentLink: function() {
      currentLink = '';
    },
    setSection: function(section) {
      title = "JPR| " + section;
    },
    currentLink: function() {
      return currentLink;
    },
    setLink: function(link) {
      currentLink = link;
    },
    getInfoMessages: function() {
      return infoMessages;
    },
    getErrorMessages: function() {
      return errorMessages;
    },
    removeInfoMessage: function(index) {
      infoMessages.splice(index, 1);
    },
    removeErrorMessage: function(index) {
      errorMessages.splice(index, 1);
    },
    hasInfoMessages: function() {
      return infoMessages.length > 0;
    },
    hasErrorMessages: function() {
      return errorMessages.length > 0;
    },
    addInfoMessage: function(message) {
      infoMessages.push(message);
    },
    addErrorMessage: function(message) {
      errorMessages.push(message);
    },
    clearInfoMessages: function() {
      infoMessages.clear();
    },
    clearErrorMessages: function() {
      errorMessages.clear();
    }, 
    setFlash: function(message){
      flashQueue.push(message);
    },
    setErrorFlash: function(message){
      errorFlashQueue.push(message);
    },
    getErrorFlash: function() {
      return errorFlash;
    },
    getFlash: function(){
      return flash;
    },
    hasFlash: function() {
      flash != '';
    },
    hasErrorFlash: function() {
      errorFlash != "";
    },
    showSpinner: function() {
      $("#spinner").show();
    }, 
    hideSpinner: function() {
      $("#spinner").hide();
    }

  };
}]);

// Authentication

jprServices.factory('Login', ['$q', '$http', 'Host', 'Auth', 'User', function($q, $http, Host, Auth, User) {
  var login = {
    auth: Auth
  };
  // Login functions
  // Attempts to retrieve a token
  // returns a promise - reason/result is status code.
  // resolved only if status is 201.
  login.performLogin = function(email, password, remember) {
    var headVal = ["Basic", btoa([email, password].join(':'))].join(' ');
    var req = {
      method: 'POST',
      url: [Host.base, 'token'].join('/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': headVal
      },
      data: {
        remember: remember.toString()
      }
    };
    var response_status = $q.defer();

    $http(req).success(function(data, status, headers, config) {

      if (status == 201) {
        Auth.setToken(data.token, data.valid_for)
        Auth.setUser(data.user, data.valid_for);
        response_status.resolve(status);
      } else {
        Auth.clear();
        response_status.reject(status);
      }

    }).error(function(data, status, headers, config) {
      Auth.clear();
      response_status.reject(status);
    });

    return response_status.promise;
  }
  return login;
}]);

jprServices.factory('Auth', ['AuthBase', 'User', function(AuthBase, User){
  var auth = {};
  auth.getUser = function(){
    return new User(AuthBase.getUser(), true);
  };
  auth.isLoggedIn = AuthBase.isLoggedIn;
  auth.setToken = AuthBase.setToken;
  auth.setUser = AuthBase.setUser;
  auth.clear = AuthBase.clear;
  return auth;
}]);

jprServices.factory('AuthBase', ['ipCookie', function(ipCookie) {
  var TOKEN_COOKIE_KEY = 'X-AUTH-TOKEN';
  var USER_COOKIE_KEY = 'CURRENT_USER';
  var auth = {};

  auth.isLoggedIn = function() {
    return ipCookie(TOKEN_COOKIE_KEY) && true;
  };

  auth.getToken = function() {
    return ipCookie(TOKEN_COOKIE_KEY);
  };

  auth.setToken = function(token, duration) {
    ipCookie(TOKEN_COOKIE_KEY, token, {
      expires: duration,
      expirationUnit: 'seconds',
      secure: false
    });
  };

  auth.setUser = function(user, duration) {
    ipCookie(USER_COOKIE_KEY, user, {
      expires: duration,
      expirationUnit: 'seconds',
      secure: false
    });
  };

  auth.getUser = function() {
    return ipCookie(USER_COOKIE_KEY);
  };
  auth.clear = function() {
    ipCookie.remove(TOKEN_COOKIE_KEY);
    ipCookie.remove(USER_COOKIE_KEY);
  };

  return auth;
}]);

jprServices.factory('Validators', function() {
  var validators = {

  };
  validators.validateEmail = function(email) {
    return email && (email.endsWith("@guc.edu.eg") || email.endsWith("@student.guc.edu.eg"));
  }

  validators.validateName = function(name) {
    return name && name.length >= 1;
  }

  validators.validatePassword = function(password) {
    return password && password.length >= 8;
  }

  validators.validateId = function(id_prefix, id_suffix) {
    return id_suffix && id_prefix && !isNaN(id_prefix) && !isNaN(id_suffix);
  }
  return validators;
});


jprServices.factory('Zen', function() {
  var zen = {};
  zen.get = function() {
    return zen.quotes[Math.floor(Math.random() * zen.quotes.length)];
  };
  zen.quotes = [
  {message:"Sitting quietly, doing nothing, Spring comes, and the grass grows by itself.", author: "Zenrin Kushû"}, 
  {message: "Entering the forest he moves not the grass; Entering the water he makes not a ripple.", author: "Zenrin Kushû"}, 
  {message: "When the task is done beforehand, then it is easy.", author: "Zen master Yuan-tong"}, 
  {message: "A day without work, a day without eating. When there's no work for a day, there's no eating for a day.", author: "Chinese Zen"}, 
  {message: "You don't have to burn books to destroy a culture. Just get people to stop reading them.", author: "Ray Bradbury" },
  {message: "I know, I know. You're afraid of making mistakes. Don’t be. Mistakes can be profited from. Man, when I was younger I shoved my ignorance in people’s faces. They beat me with sticks. By the time I was forty my blunt instrument had been honed to a fine cutting point for me. If you hide your ignorance, no one will hit you and you’ll never learn.", author: "Ray Bradbury"},
  {message: "The computing scientist’s main challenge is not to get confused by the complexities of his own making.", author: "Edsger W. Dijkstra"}, 
  {message: "When in doubt, use brute force.", author: "Ken Thompson"},
  {message: "Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it.", author: "Brian Kernighan"},
  {message: "Controlling complexity is the essence of computer programming.", author: "Brian Kernighan"}, 
  {message: "The essence of XML is this: the problem it solves is not hard, and it does not solve the problem well.", author: "Phil Wadler"},
  {message: "A program that produces incorrect results twice as fast is infinitely slower.", author: "John Osterhout"}, 
  {message: "Simplicity is prerequisite for reliability.", author: "Edsger W. Dijkstra"}, 
  {message: "Measuring programming progress by lines of code is like measuring aircraft building progress by weight.", author: "Bill Gates"}, 
  {message: "First, solve the problem. Then, write the code.", author: "John Johnson"},
  {message: "Theory is when you know something, but it doesn’t work. Practice is when something works, but you don’t know why. Programmers combine theory and practice: Nothing works and they don’t know why.", author: "Unknown"},
  {message: "A computer is a stupid machine with the ability to do incredibly smart things, while computer programmers are smart people with the ability to do incredibly stupid things. They are, in short, a perfect match", author: "Unknown"},
  {message: "If we’d asked the customers what they wanted, they would have said “faster horses”", author: "Henry Ford"}, 
  {message: "You can’t have great software without a great team, and most software teams behave like dysfunctional families.", author: "Jim McCarthy"},
  {message: "Software efficiency halves every 18 months, compensating Moore’s Law.", author: "May's Law"},
  {message: "If you give someone a program, you will frustrate them for a day; if you teach them how to program, you will frustrate them for a lifetime.", author: "David Leinweber"}, 
  {message: "It is a miracle that curiosity survives formal education.", author: "Albert Einstein"}, 
  {message: "Never let your schooling interfere with your education.", author: "Mark Twain"},
  {message: "If you have too many special cases, you are doing it wrong.", author: "Craig Zerouni"}, 
  {message: "The true sign of intelligence is not knowledge but imagination.", author: "Albert Einstein"}, 
  {message: "If people are good only because they fear punishment, and hope for reward, then we are a sorry lot indeed.", author: "Albert Einstein"},
  {message: "Saying that Java is good because it works on all platforms is like saying anal sex is good because it works on all genders.", author: "Unknown"},
  {message: "Stop guessing and start asking.", author: "Unknown"},
  {message: "After three days without programming, life becomes meaningless.", author: "The Tao of programming"},
  {message: "Testing shows the presence, not the absence of bugs.", author: "Edsger W. Dijkstra"},
  {message: "We must be very careful when we give advice to younger people: sometimes they follow it!", author: "Edsger W. Dijkstra"},
  {message: "Besides a mathematical inclination, an exceptionally good mastery of one's native tongue is the most vital asset of a competent programmer.", author: "Edsger W. Dijkstra"},
  {message: "I mean, if 10 years from now, when you are doing something quick and dirty, you suddenly visualize that I am looking over your shoulders and say to yourself “Dijkstra would not have liked this”, well, that would be enough immortality for me.", author: "Edsger W. Dijkstra"},
  
  ];
  return zen;
});
