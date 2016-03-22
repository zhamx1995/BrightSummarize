# BrightSummarize

##Overview:

This is an iOS application for article summary, implemented with the "Text Summarization API" from Mashape. The objective-C files for the provided API have already been added to the project, thus no other dependencies need to be inserted. 
**Please note, the API service would only last for 1 month, ending on Apr 21, 2016. The author would terminate the payment for the API then.**
The deployment target is iOS 9.2, and it is tested that the app works well on iPhone 5s. Users can either enter URL to the article, or copy the article text to generate the summary, which could be copied to other platforms (email, note, chat...). The summary can also be saved in the core data, and users are allowed to modify, update and delete the summaries.

##Setup:

1. Downloading the project code
2. Open BrightSummarize.xcodeproj
3. Run on simulator or iPhone connected to the computer

##Screenshots:

Main page

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/8942049/13948838/c3c3a058-eff8-11e5-8809-fb234f89a6c9.png" width="200"/>
</p>

Choose URL or plain text for summary source

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/8942049/13948876/f03b7124-eff8-11e5-984b-503d1e9a124e.png" width="200"/>
</p>

Selecting URL as source usually takes longer than plain text, please hold on for the result to show up. Each sentence in the summary is labeled with a number at the beginning. Sometimes the API cannot extract texts from the URL, and an apologize message will be displayed in the summary for this case. An alert message will pop up if the Internet connection is bad. 

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/8942049/13948885/fae04096-eff8-11e5-982e-68c084e9d34d.png" width="200"/>
<img src="https://cloud.githubusercontent.com/assets/8942049/13948884/f9b94d8e-eff8-11e5-9b18-25306f3f0d5e.png" width="200"/>
</p>

All summaries saved on the phone will be listed in the Bookmark, in an order of most-recent added to the least starting from the top. Users can delete one summary by sliding to the left, or look into the details of that summary by selecting the row. In the BookmarkDetail page, both source (URL or original text) and the summary are displayed. Users are allowed to modify and update the summary, if they come up with a better one.

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/8942049/13948898/040e4e74-eff9-11e5-89ff-7c247200fce9.png" width="200"/>
<img src="https://cloud.githubusercontent.com/assets/8942049/13948880/f53a46d2-eff8-11e5-8e0d-9a4eac978764.png" width="200"/>
<img src="https://cloud.githubusercontent.com/assets/8942049/13948906/0c59aae2-eff9-11e5-9702-211defe4120f.png" width="200"/>
</p>


Thanks to documentations provided by "Text Summerization API": https://market.mashape.com/textanalysis/text-summarization

Except the API service from Mashape, Copyright © 2016 Bright(Mingxuan) Zha. All rights reserved.