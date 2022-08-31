import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gallary_app/bloc/app_bloc.dart';
import 'package:gallary_app/bloc/app_event.dart';
import 'package:gallary_app/bloc/app_state.dart';
import 'package:gallary_app/views/main_pop_up_menu_button.dart';
import 'package:gallary_app/views/storage_image_view.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // as long as the key is same the image picker will be same instance.
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image == null) {
                return;
              } else {
                context.read<AppBloc>().add(
                      AppEventUploadImage(
                        filePathToUpload: image.path,
                      ),
                    );
              }
            },
            icon: const Icon(
              Icons.upload,
            ),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(5),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images.map((img) => StorageImageView(image: img)).toList(),
      ),
    );
  }
}
