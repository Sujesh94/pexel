import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:pexel/core/api_req/photo_list_api.dart';
import 'package:pexel/core/model/photo_list_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;

  PhotoListApi _photoListApi = new PhotoListApi();
  PhotoListModel _photoListModel = new PhotoListModel();

  @override
  void initState() {
    super.initState();
    _getPhotoList();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _getPhotoList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _photoListModel = await _photoListApi.photoList();

      setState(() {
        _photoListModel = _photoListModel;
        _isLoading = false;
      });
    } catch (err) {
      throw err;
    }
  }

  _getMorePhoto() async {
    try {
      PhotoListModel photoListModel =
          await _photoListApi.photoList(_photoListModel.nextPage);

      setState(() {
        _photoListModel.nextPage = photoListModel.nextPage;
        _photoListModel.photos!.addAll(photoListModel.photos!);
      });
    } catch (err) {
      throw err;
    }
  }

  /// function which will help to load more items to list when scrolling
  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_scrollController.position.extentAfter < 200) {
        _getMorePhoto();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener(
      onNotification: _onScrollNotification,
      child: ListView(controller: _scrollController, children: [
        _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _photoListModel.photos!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index.isEven) return SizedBox();

                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _downloadImage(_photoListModel
                                      .photos![index].src!.original!);

                      
                                },
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: FadeInImage.assetNetwork(
                                        fadeInCurve: Curves.bounceIn,
                                        placeholder: "assets/image/loading.png",
                                        image: _photoListModel
                                            .photos![index].src!.medium!),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.more_horiz,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _photoListModel.photos!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index.isOdd) return SizedBox();
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _downloadImage(_photoListModel
                                      .photos![index].src!.original!);
                                },
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: FadeInImage.assetNetwork(
                                        fadeInCurve: Curves.bounceIn,
                                        placeholder: "assets/image/loading.png",
                                        image: _photoListModel
                                            .photos![index].src!.medium!),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.more_horiz,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ]),
    ));
  }


  _downloadImage(String image) async {
    try {
      var snackBarContent = SnackBar(
        content: Text("Downloading..."),
        backgroundColor: Colors.grey[800],
        duration: Duration(seconds: 4),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
      var imageId = await ImageDownloader.downloadImage(image);
      if (imageId == null) {
        return;
      }

      var fileName = await ImageDownloader.findName(imageId);

      snackBarContent = SnackBar(
        content: Text("Downloaded $fileName"),
        backgroundColor: Colors.grey[800],
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
    } on PlatformException catch (error) {
      print(error);
    }
  }
}

// Image(
//   image: NetworkImage(_photoListModel
//       .photos![index].src!.medium!),
//   fit: BoxFit.cover,
//   width: MediaQuery.of(context).size.width /
//       2.01,
//   height: _photoListModel
//           .photos![index].height! /
//       22,
//   loadingBuilder: (BuildContext context,
//       Widget child,
//       ImageChunkEvent? loadingProgress) {
//     if (loadingProgress == null) {
//       return child;
//     }
//     return Center(
//       child: CircularProgressIndicator(
//         value: loadingProgress
//                     .expectedTotalBytes !=
//                 null
//             ? loadingProgress
//                     .cumulativeBytesLoaded /
//                 loadingProgress
//                     .expectedTotalBytes!
//             : null,
//       ),
//     );
//   },
// ),
