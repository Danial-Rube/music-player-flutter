import 'package:flutter/material.dart';
import 'dart:ui';
import 'song.dart';
import 'verifytool.dart';

class SongDetailPage extends StatefulWidget {
  final Song song;
  final Function(Song) onPaymentComplete;

  const SongDetailPage({
    super.key,
    required this.song,
    required this.onPaymentComplete,
  });

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage>
    with TickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //  بکگراند  تنظیمات
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child:
                widget.song.artwork != null
                    ? Image.memory(widget.song.artwork!, fit: BoxFit.cover)
                    : Image.asset(widget.song.coverPath, fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),

          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Song\'s Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Opensans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // For balance
                    ],
                  ),
                ),

                // محتوای اصلی
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // کاور آلبوم
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 300, // Increased size
                                  height: 300, // Increased size

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        widget.song.artwork != null
                                            ? Image.memory(
                                              widget.song.artwork!,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.asset(
                                              widget.song.coverPath,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  color: Colors.grey[800],
                                                  child: const Icon(
                                                    Icons.music_note,
                                                    size: 100,
                                                    color: Colors.white54,
                                                  ),
                                                );
                                              },
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // نام اهنگ و ارتیست
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.song.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontFamily: 'Opensans',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.song.artist,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontFamily: 'Opensans',
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // استارز
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return TweenAnimationBuilder(
                                  duration: Duration(
                                    milliseconds: 300 + (index * 100),
                                  ),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  builder: (context, double value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Icon(
                                        index < widget.song.stars.floor()
                                            ? Icons.star
                                            : (index < widget.song.stars
                                                ? Icons.star_half
                                                : Icons.star_border),
                                        color: Colors.blue,
                                        size: 32,
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // تب کامنت و جزئیات
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              controller: _tabController,

                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.white70,
                              tabs: const [
                                Tab(text: 'Details'),
                                Tab(text: 'Comments'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // محتوای تب
                          SizedBox(
                            height: 400, // Fixed height for tab content
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Song
                                _buildSongDetailsTab(),

                                // Comments
                                _buildCommentsTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongDetailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(),

        const SizedBox(height: 24),

        // دکمه ی پرداخت
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              widget.onPaymentComplete(widget.song);
            },
            child: const Text(
              'Pay and Download',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [
          _buildDetailRow(
            Icons.music_note,
            'Gener',
            widget.song.genre ?? 'Unknown',
          ),
          const Divider(color: Colors.white24, height: 24),
          _buildDetailRow(
            Icons.attach_money,
            'Price',
            '${widget.song.price} \$',
          ),
          const Divider(color: Colors.white24, height: 24),
          _buildDetailRow(
            Icons.download,
            'Downloads',
            '${widget.song.downloadCount}',
          ),
          if (widget.song.duration != null) ...[
            const Divider(color: Colors.white24, height: 24),
            _buildDetailRow(
              Icons.timer,
              'Time',
              '${widget.song.duration!.inMinutes}:${(widget.song.duration!.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'Opensans',
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Opensans',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsTab() {
    return Column(
      children: [
        // Comments list
        Expanded(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(16),
            child:
                _comments.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white.withOpacity(0.3),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Comments yet',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white24,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      activeUser!.name,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _comments[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),

        const SizedBox(height: 16),

        // فیلد اضافه کردن کامنت
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Write...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  onPressed: () {
                    if (_commentController.text.trim().isNotEmpty) {
                      setState(() {
                        _comments.add(_commentController.text.trim());
                        _commentController.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
