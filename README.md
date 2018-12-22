# ifood-mobile-test
Create an app that given an Twitter username it will list user's tweets. When I tap one of the tweets the app will visualy indicate if it's a happy, neutral or sad tweet.

## Business rules
* Happy Tweet: We want a vibrant yellow color on screen with a 😃 emoji
* Neutral Tweet: We want a grey colour on screen with a 😐 emoji
* Sad Tweet: We want a blue color on screen with a 😔 emoji
* For the first release we will only support english language

### Hints
* You may use Twitter's oficial API (https://developer.twitter.com) to fetch user's tweets 
* Google's Natural Language API (https://cloud.google.com/natural-language/) may help you with sentimental analysis.

## Non functional requirements
* As this app will be a worldwide success, it must be prepared to be fault tolerant, responsive and resilient.
* Use whatever language, tools and frameworks you feel comfortable to.
* Briefly elaborate on your solution, architecture details, choice of patterns and frameworks.
* Fork this repository and submit your code.

# Solution
Current implementation is fetching data from dynamic mocks. Ideal implementation include Network Workers implementation to fetch real data, with In Memory and CoreData Cache Workers.

User search dynamic mock verifies if username contains "private", "verified" or "inexistent" words and reflect into returned user's properties.

It's a single screen app with a username search field and, when correctly filled, shows user's timeline tweets in a list. When each tweet is clicked, item expands revealing tweet's details and corresponding text's sentimental analysis result.

## Architecture
It was mainly based onto a Clean Swift's VIP cycle variation with introduction of a protocol based variation of Matteo Manferdini's Inert View Models strategy (https://matteomanferdini.com/mvvm-pattern-ios-swift/).

It was also aimed into satisfying SOLID principles and into safe implementation by heavily avoiding force unwrapping optionals and providing default values as needed. Many objects already depends on protocols, but in some cases direct concrete implementation instantiation was used for simplicity sake. Also, some code portions uses generic approaches.

The project don't have any external dependency by now.

UI basically utilizes UIStackViews and AutoLayout constraints.

## Known issues/Planned but not implemented features
* Request authentication interceptors (Twitter/Google APIs)
* Network workers
* Cache workers (In memory/CoreData)
* Google's sentimental analysis response model parsing
* User's profile image fetching/caching
* Keyboard handling
* UI/Layout improvements
* More dependency injection
* TimelinePresenter's concerns separation/roles division
* Unit/UI tests
* Localization
* Accessibility
