// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';

// =============================================================================
// ENUMS
// =============================================================================
enum IndicatorStyle { dot, line, scale, slide, number }

// =============================================================================
// DATA MODELS
// =============================================================================
class CarouselItem {
  final String? imageUrl;
  final String? title;
  final String? id;
  final String? description;
  final VoidCallback? onTap;

  CarouselItem({this.imageUrl, this.title, this.description, this.id, this.onTap});
}

// =============================================================================
// INDICATOR WIDGET
// =============================================================================
class CarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Function(int)? onTap;
  final IndicatorStyle style;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? size;

  const CarouselIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.onTap,
    this.style = IndicatorStyle.dot,
    this.activeColor,
    this.inactiveColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = activeColor ?? Theme.of(context).primaryColor;
    final secondaryColor = inactiveColor ?? Colors.grey.withOpacity(0.4);

    switch (style) {
      case IndicatorStyle.line:
        return _buildLineIndicator(primaryColor, secondaryColor);
      case IndicatorStyle.scale:
        return _buildScaleIndicator(primaryColor, secondaryColor);
      case IndicatorStyle.slide:
        return _buildSlideIndicator(context, primaryColor, secondaryColor);
      case IndicatorStyle.number:
        return _buildNumberIndicator(context, primaryColor);
      default:
        return _buildDotIndicator(primaryColor, secondaryColor);
    }
  }

  Widget _buildDotIndicator(Color activeColor, Color inactiveColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        bool isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: size ?? 8.0,
            height: size ?? 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? activeColor : inactiveColor),
          ),
        );
      }),
    );
  }

  Widget _buildLineIndicator(Color activeColor, Color inactiveColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        bool isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? (size ?? 20.0) : (size ?? 8.0),
            height: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScaleIndicator(Color activeColor, Color inactiveColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        bool isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? (size ?? 12.0) : (size ?? 8.0),
            height: isActive ? (size ?? 12.0) : (size ?? 8.0),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor : inactiveColor,
              border: isActive ? Border.all(color: activeColor.withOpacity(0.3), width: 2) : null,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSlideIndicator(BuildContext context, Color activeColor, Color inactiveColor) {
    return SizedBox(
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(itemCount, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(shape: BoxShape.circle, color: inactiveColor),
              );
            }),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: (currentIndex * 16.0) + (MediaQuery.of(context).size.width / 2) - (itemCount * 8.0) - 6,
            child: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(shape: BoxShape.circle, color: activeColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberIndicator(BuildContext context, Color activeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: activeColor.withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
      child: Text(
        '${currentIndex + 1} / $itemCount',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// =============================================================================
// IMAGE CAROUSEL SLIDER
// =============================================================================
class ImageCarouselSlider extends StatefulWidget {
  final List<CarouselItem> imageUrls;
  
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool showDots;
  final IndicatorStyle indicatorStyle;
  final Color? indicatorActiveColor;
  final Color? indicatorInactiveColor;
  final Function(CarouselItem value)? onChange;

  const ImageCarouselSlider({
    super.key,
    required this.imageUrls,
    this.height = 200.0,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showDots = true,
    this.indicatorStyle = IndicatorStyle.dot,
    this.indicatorActiveColor,
    this.indicatorInactiveColor,
    this.onChange,
  });

  @override
  State<ImageCarouselSlider> createState() => _ImageCarouselSliderState();
}

class _ImageCarouselSliderState extends State<ImageCarouselSlider> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCarousel(),
        if (widget.showDots) ...[const SizedBox(height: 16), _buildIndicator()],
      ],
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider.builder(
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index, realIndex) {
        return GestureDetector(
          onTap: () => widget.onChange!(widget.imageUrls[index]),
          child: _buildImageItem(widget.imageUrls[index].imageUrl ?? ""),
        );
      },
      options: CarouselOptions(
        clipBehavior: Clip.none,
        height: widget.height,
        autoPlay: widget.autoPlay,
        autoPlayInterval: widget.autoPlayInterval,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        viewportFraction: 0.8,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildImageItem(String imageUrl) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoadingWidget(loadingProgress);
          },
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(ImageChunkEvent loadingProgress) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          value:
              loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        color: Get.isDarkMode ? AppColors.accentColor.withValues(alpha: 0.6) : AppColors.white,
        child: Icon(Icons.broken_image, size: 60, color: Get.isDarkMode ? Colors.white : AppColors.accentColor),
      ),
    );
  }

  Widget _buildIndicator() {
    return CarouselIndicator(
      itemCount: widget.imageUrls.length,
      currentIndex: _currentIndex,
      style: widget.indicatorStyle,
      activeColor: widget.indicatorActiveColor,
      inactiveColor: widget.indicatorInactiveColor,
      onTap:
          (index) => _carouselController.animateTo(1.0, duration: Duration(microseconds: 2000), curve: Curves.bounceIn),
    );
  }
}

// =============================================================================
// CONTENT CAROUSEL SLIDER
// =============================================================================
class ContentCarouselSlider extends StatefulWidget {
  final List<CarouselItem> items;
  final double height;
  final bool autoPlay;
  final IndicatorStyle indicatorStyle;
  final Color? indicatorActiveColor;
  final Color? indicatorInactiveColor;

  const ContentCarouselSlider({
    super.key,
    required this.items,
    this.height = 250.0,
    this.autoPlay = false,
    this.indicatorStyle = IndicatorStyle.dot,
    this.indicatorActiveColor,
    this.indicatorInactiveColor,
  });

  @override
  State<ContentCarouselSlider> createState() => _ContentCarouselSliderState();
}

class _ContentCarouselSliderState extends State<ContentCarouselSlider> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildCarousel(), const SizedBox(height: 16), _buildIndicator()]);
  }

  Widget _buildCarousel() {
    return CarouselSlider.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index, realIndex) {
        return _buildContentItem(widget.items[index]);
      },
      options: CarouselOptions(
        height: widget.height,
        autoPlay: widget.autoPlay,
        autoPlayInterval: const Duration(seconds: 4),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildContentItem(CarouselItem item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [if (item.imageUrl != null) _buildItemImage(item.imageUrl!), _buildItemContent(item)],
      ),
    );
  }

  Widget _buildItemImage(String imageUrl) {
    return Expanded(
      flex: 3,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(child: Icon(Icons.image, color: Colors.grey)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemContent(CarouselItem item) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item.title != null) ...[
              Text(
                item.title!,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
            ],
            if (item.description != null) ...[
              Text(
                item.description!,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (item.onTap != null) ...[
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: item.onTap, child: const Text('Read More')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return CarouselIndicator(
      itemCount: widget.items.length,
      currentIndex: _currentIndex,
      style: widget.indicatorStyle,
      activeColor: widget.indicatorActiveColor,
      inactiveColor: widget.indicatorInactiveColor,
      onTap:
          (index) => _carouselController.animateTo(1.0, duration: Duration(microseconds: 2000), curve: Curves.bounceIn),
    );
  }
}

// =============================================================================
// EXAMPLE USAGE PAGE
// =============================================================================
class CarouselExamplePage extends StatelessWidget {
  const CarouselExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carousel Slider Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildImageCarouselSection(context),
            const SizedBox(height: 32),
            // _buildContentCarouselSection(context),
            const SizedBox(height: 32),
            _buildIndicatorExamplesSection(context),
            const SizedBox(height: 32),
            _buildSimpleCarouselSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorExamplesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Indicator Styles', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        _buildIndicatorExample(context, 'Dot', IndicatorStyle.dot, 2),
        const SizedBox(height: 12),
        _buildIndicatorExample(context, 'Line', IndicatorStyle.line, 1),
        const SizedBox(height: 12),
        _buildIndicatorExample(context, 'Scale', IndicatorStyle.scale, 0),
        const SizedBox(height: 12),
        _buildIndicatorExample(context, 'Number', IndicatorStyle.number, 3),
      ],
    );
  }

  Widget _buildIndicatorExample(BuildContext context, String title, IndicatorStyle style, int currentIndex) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          CarouselIndicator(
            itemCount: 5,
            currentIndex: currentIndex,
            style: style,
            onTap: (index) => print('$title $index tapped'),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCarouselSection(BuildContext context) {
    final quotes = [
      'The journey of a thousand miles begins with one step.',
      'Life is what happens when you\'re busy making other plans.',
      'The future belongs to those who believe in the beauty of their dreams.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Simple Text Carousel', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        CarouselSlider.builder(
          itemCount: quotes.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor.withOpacity(0.8), Theme.of(context).primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: Text(
                  quotes[index],
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
          ),
        ),
      ],
    );
  }
}
