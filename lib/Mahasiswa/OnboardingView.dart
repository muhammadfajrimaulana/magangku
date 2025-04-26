import 'package:flutter/material.dart';
import 'package:magangku/Mahasiswa/LoginPage.dart';

const Color fontGrayColor = Color(0xFF888888);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Magangku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Widget> onboardingLayouts = [
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Bungkus Column dengan SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/onboarding1.png'),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang di Magangku!',
              style: TextStyle(
                fontFamily: "InterBold",
                fontSize: 25,
                color: Color.fromARGB(255, 9, 4, 159),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Buat laporan magang secara otomatis dan cepat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "InterMedium",
                fontSize: 15,
                color: fontGrayColor,
              ),
            ),
          ],
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/onboarding4.png'),
            const SizedBox(height: 20),
            const Text(
              'Fitur Unggulan',
              style: TextStyle(
                fontFamily: "InterBold",
                fontSize: 25,
                color: Color.fromARGB(255, 9, 4, 159),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nikmati fitur canggih yang akan membantu menyelesaikan laporan dengan mudah',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "InterMedium",
                fontSize: 15,
                color: fontGrayColor,
              ),
            ),
          ],
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/onboarding3.png'),
            const SizedBox(height: 20),
            const Text(
              'Mulai Sekarang!',
              style: TextStyle(
                fontFamily: "InterBold",
                fontSize: 25,
                color: Color.fromARGB(255, 9, 4, 159),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tunggu apa lagi? Mulai gunakan aplikasi Magangku sekarang dan rasakan kemudahannya!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "InterMedium",
                fontSize: 15,
                color: fontGrayColor,
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            _currentPage > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                )
                : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingLayouts.length,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(layout: onboardingLayouts[index]);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingLayouts.length, (index) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index
                              ? const Color.fromARGB(255, 4, 81, 144)
                              : Colors.grey,
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < onboardingLayouts.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 81, 144),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: Text(
                        _currentPage < onboardingLayouts.length - 1
                            ? 'Lanjutkan'
                            : 'Mulai',
                        style: const TextStyle(
                          fontFamily: "InterSemibold",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Lewati",
                        style: TextStyle(
                          fontFamily: "InterSemibold",
                          fontSize: 14,
                          color: fontGrayColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final Widget layout;

  const OnboardingPage({super.key, required this.layout});

  @override
  Widget build(BuildContext context) {
    return layout;
  }
}
