# Acharya Prashant Foundation

## Overview

This iOS application efficiently loads and displays images in a scrollable grid. It implements features such as image grid, asynchronous image loading, caching mechanism, error handling, and smooth scrolling. The project is implemented in Swift using native technology.


## Tasks

### Image Grid

The app displays a 3-column square image grid. Images are center-cropped to fit the grid.

### Image Loading

Implemented asynchronous image loading utilizing the specified URL from
https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100.

To enhance efficiency, redundant image download requests are consolidated into a single request when users scroll, with priorities adjusted according to requirements.

### Display

Users can scroll through at least 100 images with no lagging. 

### Caching

A caching mechanism is developed to store images retrieved from the API in both memory and disk cache for efficient retrieval. If an image is missing in memory cache, it should be fetched from the disk cache. When an image is read from the disk, the memory cache should be updated.

### Error Handling

The app gracefully handles network errors and image loading failures when fetching images from the API, 


## Modules

### Network

Developed a robust network layer to handle API calls and their endpoints efficiently.

### ImageLoader

The ImageLoader component serves as a facilitator for the dashboard, aiding in the storage of all feed data and image cache within the application.

### ImageCacheHelper

Utilizing the ImageCacheHelper, this component efficiently stores and retrieves image data from the disk, enhancing performance and data management.

### ImageDownloader

The ImageDownloader module manages image downloads, allowing for the adjustment of download priorities. Additionally, it offers functionality to pause, resume, and cancel downloads as needed, providing users with control over their downloads.

### ProgressLoader

An integrated Progress Loader offers visual feedback to users during API responses, enhancing user engagement and transparency throughout the application.

### ToastView

Integrated Toast View functionality displays error messages within the app, providing users with prompt notifications in the event of errors or API failures.

## Instructions

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the project on a simulator or a physical device.
4. Navigate through the image grid by scrolling vertically.
5. Monitor network activity and observe how the app handles image loading and caching.

## Note
For debugging purposes:
A delete button is added at the top right corner of the navigation bar, offering three options:

1. Clear Memory Cache: Deletes all images stored in memory by the app, without reloading the screen.
2. Clear Disk Cache: Deletes all images stored on disk by the app, without reloading the screen.
3. Refresh Feeds: Calls the feed API again in the dashboard and then reloads the screen."


## Contact

For any questions or feedback, please contact:
- Email: ashoksolanki2001@gmail.com
- Twitter: @ashoksolanki266
