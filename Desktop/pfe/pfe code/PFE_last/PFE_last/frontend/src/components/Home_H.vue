<template>
    <div class="home-container">
      <!-- FontAwesome Icons -->
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
      <!-- Header Section -->
      <header class="header">
        <div class="logo-section">
        <img src="../assets/logo.jpg" alt="QuikDoc Logo" class="logo">
        <h1 class="site-name">QuikDoc</h1>
        </div>
        <div class="nav-links">
         <a href="#services" class="nav-link" @click="(e) => scrollToSection(e, 'services')">Nos Services</a>
         <a href="#functionalities" class="nav-link" @click="(e) => scrollToSection(e, 'functionalities')">Nos Fonctionnalités</a>
         <a href="#testimonials" class="nav-link" @click="(e) => scrollToSection(e, 'testimonials')">Témoignages</a>
         <a href="#about" class="nav-link" @click="(e) => scrollToSection(e, 'about')">À propos de nous</a>
         <a href="#contact" class="nav-link" @click="(e) => scrollToSection(e, 'contact')">Contactez-nous</a>
        </div>
        <div class="auth-buttons">
         <button class="btn btn-outline" @click="navigateTo('/connexion')">Connecter</button>
         <button class="btn btn-solid" @click="navigateTo('/inscription')">Créer un compte</button>
        </div>
      </header>
  
      <!-- Main Content Section -->
      <main class="main-content">
        <div class="hero-section">
          <div class="hero-text">
            <h2 class="hero-title">Automatiser, Personnaliser, Simplifier – Pour une entreprise plus efficace</h2>
            <p class="hero-description">
              Notre solution révolutionne la gestion des devis et factures en intégrant l'intelligence artificielle (IA) et la reconnaissance optique de caractères (OCR), offrant ainsi aux entreprises une automatisation avancée et une gestion plus intelligente de leurs documents comptables.
            </p>
            <button class="btn btn-primary btn-large" @click="navigateTo('/inscription')">
                Commencer maintenant
           </button>
          </div>
          <div class="hero-image">
            <img src="../assets/homebackground.jpg" alt="Business Management" class="main-image">
          </div>
        </div>
  
        <div id="services" class="features-section">
          <h2 class="section-title">Nos Services</h2>
          <div class="features-carousel" ref="carousel">
            <div class="feature-card" v-for="(service, index) in services" :key="'serv-'+index">
              <div class="card-icon">
                <i :class="service.icon"></i>
              </div>
              <div class="card-content">
                <h3>{{ service.title }}</h3>
                <p>{{ service.description }}</p>
              </div>
            </div>
          </div>
          <div class="carousel-navigation">
            <div class="carousel-controls">
              <button class="control-btn prev" @click="prevSlide">&#8592;</button>
              <button class="control-btn next" @click="nextSlide">&#8594;</button>
            </div>
            <div class="carousel-indicator">
              <span 
                v-for="(_, index) in services" 
                :key="'ind-'+index"
                :class="{ active: currentSlide === index }"
                @click="goToSlide(index)"
              ></span>
            </div>
          </div>
  
          <h2 id="functionalities" class="section-title">Nos Fonctionnalités</h2>
          <div class="features-carousel" ref="functionalitiesCarousel">
            <div class="feature-card" v-for="(functionality, index) in functionalities" :key="'func-'+index">
              <div class="card-icon">
                <i :class="functionality.icon"></i>
              </div>
              <div class="card-content">
                <h3>{{ functionality.title }}</h3>
                <p>{{ functionality.description }}</p>
              </div>
            </div>
          </div>
          <div class="carousel-navigation">
            <div class="carousel-controls">
              <button class="control-btn prev" @click="prevFunctionalitySlide">&#8592;</button>
              <button class="control-btn next" @click="nextFunctionalitySlide">&#8594;</button>
            </div>
            <div class="carousel-indicator">
              <span 
                v-for="(_, index) in functionalities" 
                :key="'ind-func-'+index"
                :class="{ active: currentFunctionalitySlide === index }"
                @click="goToFunctionalitySlide(index)"
              ></span>
            </div>
          </div>
        </div>

        <!-- Testimonials Section -->
        <div id="testimonials" class="testimonials-section">
          <h2 class="section-title">Ce que nos clients disent</h2>
          <div class="features-carousel" ref="testimonialsCarousel">
            <div class="testimonial-card" v-for="(testimonial, index) in testimonials" :key="'test-'+index">
              <div class="testimonial-header">
                <div class="testimonial-avatar">
                  <i :class="testimonial.avatar"></i>
                </div>
                <div class="testimonial-info">
                  <h3 class="testimonial-name">{{ testimonial.name }}</h3>
                  <p class="testimonial-position">{{ testimonial.position }}</p>
                </div>
              </div>
              <div class="testimonial-content">
                <i class="fas fa-quote-left quote-icon"></i>
                <p class="testimonial-text">{{ testimonial.text }}</p>
                <div class="testimonial-rating">
                  <i class="fas fa-star" v-for="star in 5" :key="'star-'+star"></i>
                </div>
              </div>
            </div>
          </div>
          <div class="carousel-navigation">
            <div class="carousel-controls">
              <button class="control-btn prev" @click="prevTestimonialSlide">&#8592;</button>
              <button class="control-btn next" @click="nextTestimonialSlide">&#8594;</button>
            </div>
            <div class="carousel-indicator">
              <span 
                v-for="(_, index) in testimonials" 
                :key="'ind-test-'+index"
                :class="{ active: currentTestimonialSlide === index }"
                @click="goToTestimonialSlide(index)"
              ></span>
            </div>
          </div>
        </div>
      </main>
  
      <!-- Footer Section -->
      <footer class="footer">
        <div class="footer-section" id="about">
          <h3 class="footer-title">À propos de nous</h3>
          <p class="footer-text">
            Nous sommes une équipe passionnée par l'innovation et la transformation digitale, dédiée à l'optimisation des processus de gestion pour les entreprises. À travers notre projet, nous mettons en avant une solution intelligente de digitalisation des devis et factures, intégrant l'intelligence artificielle (IA) et la reconnaissance optique de caractères (OCR).
          </p>
          <div class="footer-cta">
             <button class="btn btn-footer" @click="navigateTo('/inscription')">Rejoignez-nous</button>
          </div>
        </div>
        <div class="footer-section" id="contact">
          <h3 class="footer-title">Contactez-nous</h3>
          <div class="contact-items">
            <div class="contact-item">
              <i class="fas fa-envelope"></i>
              <span>contact@quikdoc.com</span>
            </div>
            <div class="contact-item">
              <i class="fas fa-phone-alt"></i>
              <span>+33 1 23 45 67 89</span>
            </div>
            <div class="contact-item">
              <i class="fas fa-map-marker-alt"></i>
              <span>123 Avenue des Affaires, 75001 Paris</span>
            </div>
          </div>
        </div>
        <div class="footer-section">
          <h3 class="footer-title">Suivez-nous</h3>
          <div class="social-icons">
            <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
            <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
            <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
            <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
          </div>
          <p class="copyright">© 2023 QuikDoc. Tous droits réservés.</p>
        </div>
      </footer>
    </div>
  </template>
  
  <script setup>
   import { ref, onMounted } from 'vue';
   import { useRouter } from 'vue-router';
  
   const router = useRouter();
   const navigateTo = (path) =>{
  router.push(path);
  };
  const carousel = ref(null);
  const functionalitiesCarousel = ref(null);
  
  const services = [
    {
      title: 'Numérisation et importation de documents physiques',
      description: 'Permet à l\'utilisateur d\'importer des documents papier (devis/factures scannés) ou PDF/images pour traitement automatique.',
      icon: 'fas fa-file-upload'
    },
    {
      title: 'Extraction intelligente de données par OCR/IA',
      description: 'Utilise la reconnaissance optique de caractères pour extraire automatiquement les informations importantes comme : nom du client, montant, date, TVA, produits/services, etc.',
      icon: 'fas fa-brain'
    },
    {
      title: 'Classification automatique des documents',
      description: 'L\'IA détecte le type de document (devis ou facture) et l\'associe au bon workflow de traitement dans la plateforme.',
      icon: 'fas fa-sort'
    },
    {
      title: 'Structuration et formatage des données extraites',
      description: 'Convertit les données OCR extraites en format structuré (JSON) pour intégration automatique dans les modules de gestion (base de données, modèles, facturation…).',
      icon: 'fas fa-code'
    },
    {
      title: 'Pré-remplissage automatique des modèles personnalisés',
      description: 'Injecte les données structurées dans les modèles personnalisés de devis/factures définis par l\'admin entreprise.',
      icon: 'fas fa-file-invoice'
    },
    {
      title: 'Suivi de performance et validation manuelle assistée',
      description: 'Affiche un tableau de fiabilité du traitement OCR/IA, permet à l\'utilisateur (admin entreprise) de corriger manuellement les erreurs si nécessaire, avec un système de suggestion intelligente.',
      icon: 'fas fa-chart-line'
    }
  ];
  const scrollToSection = (event, targetId) => {
  event.preventDefault();
  const targetElement = document.getElementById(targetId);
  if (targetElement) {
    const headerHeight = 70; // Height of the fixed header
    const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - headerHeight;
    window.scrollTo({
      top: targetPosition,
      behavior: 'smooth'
    });
  }
};
  
  const functionalities = [
    {
      title: 'Reconnaissance et extraction automatique des données',
      description: 'L\'OCR identifie les informations clés des documents (nom du client, montant, date, TVA, etc.) et les intègre dans le système.',
      icon: 'fas fa-file-alt'
    },
    {
      title: 'Génération et personnalisation des devis et factures',
      description: 'Possibilité de créer des documents sur mesure avec des modèles dynamiques adaptés aux préférences de l\'entreprise.',
      icon: 'fas fa-file-invoice'
    },
    {
      title: 'Archivage et organisation intelligente',
      description: 'Classement automatique des documents avec un moteur de recherche avancé pour un accès rapide et simplifié.',
      icon: 'fas fa-archive'
    },
    {
      title: 'Automatisation des validations et des envois',
      description: 'Workflow intelligent permettant d\'envoyer directement les factures aux clients et de suivre leur état (envoyé, validé, payé).',
      icon: 'fas fa-paper-plane'
    },
    {
      title: 'Intégration avec d\'autres outils',
      description: 'Compatibilité avec des logiciels comptables et ERP pour une synchronisation fluide des données.',
      icon: 'fas fa-plug'
    },
    {
      title: 'Apprentissage et amélioration continue',
      description: 'Grâce à l\'IA, le système s\'adapte et améliore progressivement la reconnaissance et la gestion des documents.',
      icon: 'fas fa-brain'
    }
  ];
  
  const testimonials = [
    
    {
      name: 'Ahmed Ben Salah',
      position: 'Directeur Commercial, TechSolutions',
      text: 'Depuis que nous utilisons QuikDoc, notre processus de facturation est devenu beaucoup plus efficace. Nous économisons plusieurs heures par semaine et nos clients apprécient la rapidité de traitement de leurs documents.',
      avatar: 'fas fa-user-circle'
    },
    {
      name: 'Noura Bouzid',
      position: 'Responsable Administrative, MediConsult',
      text: 'QuikDoc nous a permis de digitaliser l\'ensemble de notre processus de gestion documentaire. La précision de l\'OCR est remarquable et le support client est toujours disponible pour nous aider.',
      avatar: 'fas fa-user-circle'
    },
    {
      name: 'Karim Trabelsi',
      position: 'PDG, Innov\'Tech',
      text: 'Je recommande vivement QuikDoc à toutes les entreprises qui souhaitent moderniser leur gestion administrative. L\'interface est intuitive et les fonctionnalités d\'IA nous ont fait gagner un temps considérable.',
      avatar: 'fas fa-user-circle'
    },
    {
      name: 'Sana Jelassi',
      position: 'Directrice Marketing, GlobalMedia',
      text: 'QuikDoc a révolutionné notre façon de gérer les documents administratifs. La plateforme est non seulement efficace mais aussi très facile à prendre en main. Un excellent investissement pour notre entreprise.',
      avatar: 'fas fa-user-circle'
    },
    {
      name: 'Mehdi Ghariani',
      position: 'Consultant Financier, FinExpert',
      text: 'En tant que consultant, je recommande QuikDoc à tous mes clients. La précision de l\'extraction des données et la facilité d\'utilisation en font un outil incontournable pour optimiser la gestion documentaire.',
      avatar: 'fas fa-user-circle'
    },
    {
      name: 'Amel Messaoudi',
      position: 'Responsable RH, Talent Solutions',
      text: 'Notre département RH utilise QuikDoc quotidiennement pour gérer les documents administratifs. La solution nous a permis d\'améliorer considérablement notre efficacité et de réduire les erreurs de traitement.',
      avatar: 'fas fa-user-circle'
    }
  ];
  
  const currentSlide = ref(0);
  const currentFunctionalitySlide = ref(0);
  const currentTestimonialSlide = ref(0);
  const testimonialsCarousel = ref(null);
  
  const goToSlide = (index) => {
    currentSlide.value = index;
    updateCarousel();
  };
  
  const goToFunctionalitySlide = (index) => {
    currentFunctionalitySlide.value = index;
    updateFunctionalitiesCarousel();
  };
  
  const nextSlide = () => {
    currentSlide.value = (currentSlide.value + 1) % services.length;
    updateCarousel();
  };
  
  const prevSlide = () => {
    currentSlide.value = (currentSlide.value - 1 + services.length) % services.length;
    updateCarousel();
  };
  
  const nextFunctionalitySlide = () => {
    currentFunctionalitySlide.value = (currentFunctionalitySlide.value + 1) % functionalities.length;
    updateFunctionalitiesCarousel();
  };
  
  const prevFunctionalitySlide = () => {
    currentFunctionalitySlide.value = (currentFunctionalitySlide.value - 1 + functionalities.length) % functionalities.length;
    updateFunctionalitiesCarousel();
  };
  
  const updateCarousel = () => {
    if (carousel.value) {
      // Calculate the scroll position based on card width
      const cards = carousel.value.querySelectorAll('.feature-card');
      if (cards.length > 0) {
        const cardWidth = cards[0].offsetWidth;
        const scrollPosition = cardWidth * currentSlide.value + (currentSlide.value * 30); // 30px is the gap
        carousel.value.scrollTo({
          left: scrollPosition,
          behavior: 'smooth'
        });
        
        // Add animation class to current card
        cards.forEach((card, index) => {
          if (index === currentSlide.value) {
            card.classList.add('animate-fade-in');
          } else {
            card.classList.remove('animate-fade-in');
          }
        });
      }
    }
  };
  
  const updateFunctionalitiesCarousel = () => {
    if (functionalitiesCarousel.value) {
      // Calculate the scroll position based on card width
      const cards = functionalitiesCarousel.value.querySelectorAll('.feature-card');
      if (cards.length > 0) {
        const cardWidth = cards[0].offsetWidth;
        const scrollPosition = cardWidth * currentFunctionalitySlide.value + (currentFunctionalitySlide.value * 30); // 30px is the gap
        functionalitiesCarousel.value.scrollTo({
          left: scrollPosition,
          behavior: 'smooth'
        });
        
        // Add animation class to current card
        cards.forEach((card, index) => {
          if (index === currentFunctionalitySlide.value) {
            card.classList.add('animate-fade-in');
          } else {
            card.classList.remove('animate-fade-in');
          }
        });
      }
    }
  };

  const goToTestimonialSlide = (index) => {
    currentTestimonialSlide.value = index;
    updateTestimonialsCarousel();
  };
  
  const nextTestimonialSlide = () => {
    currentTestimonialSlide.value = (currentTestimonialSlide.value + 1) % testimonials.length;
    updateTestimonialsCarousel();
  };
  
  const prevTestimonialSlide = () => {
    currentTestimonialSlide.value = (currentTestimonialSlide.value - 1 + testimonials.length) % testimonials.length;
    updateTestimonialsCarousel();
  };
  
  const updateTestimonialsCarousel = () => {
    if (testimonialsCarousel.value) {
      // Calculate the scroll position based on card width
      const cards = testimonialsCarousel.value.querySelectorAll('.testimonial-card');
      if (cards.length > 0) {
        const cardWidth = cards[0].offsetWidth;
        const scrollPosition = cardWidth * currentTestimonialSlide.value + (currentTestimonialSlide.value * 30); // 30px is the gap
        testimonialsCarousel.value.scrollTo({
          left: scrollPosition,
          behavior: 'smooth'
        });
        
        // Add animation class to current card
        cards.forEach((card, index) => {
          if (index === currentTestimonialSlide.value) {
            card.classList.add('animate-fade-in');
          } else {
            card.classList.remove('animate-fade-in');
          }
        });
      }
    }
  };
  
 
  
  onMounted(() => {
    updateCarousel();
    updateFunctionalitiesCarousel();
    updateTestimonialsCarousel();
    
    // Add scroll event listener for animations
    const animateOnScroll = () => {
      const elements = document.querySelectorAll('.feature-card, .section-title, .hero-text, .hero-image, .testimonial-card');
      elements.forEach((element, index) => {
        const elementTop = element.getBoundingClientRect().top;
        const windowHeight = window.innerHeight;
        if (elementTop < windowHeight - 100) {
          element.classList.add('animate-on-scroll');
          // Add staggered animation for testimonial cards
          if (element.classList.contains('testimonial-card')) {
            element.style.setProperty('--i', index % 3);
          }
        }
      });
    };
    
    window.addEventListener('scroll', animateOnScroll);
    animateOnScroll(); // Initial check
    
    // Add pulse animation to the main CTA button
    const ctaButton = document.querySelector('.btn-primary');
    if (ctaButton) {
      ctaButton.classList.add('pulse-animation');
    }
  });
  </script>
  
  <style scoped>
  html {
  scroll-behavior: smooth;
  }
  /* Global Styles */
  .home-container {
  font-family: 'Arial', sans-serif;
  color: #333;
  line-height: 1.6;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  overflow-x: hidden;
  scroll-padding-top: 70px; 
}
  
  /* Animation Styles */
  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }
  
  @keyframes floatUp {
    from { transform: translateY(20px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
  }
  
  @keyframes slideInLeft {
    from { transform: translateX(-50px); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
  }
  
  @keyframes slideInRight {
    from { transform: translateX(50px); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
  }
  
  @keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
  }
  
  .animate-fade-in {
    animation: fadeIn 1s ease-out forwards;
  }
  
  .animate-slide-in-left {
    animation: slideInLeft 1s ease-out forwards;
  }
  
  .animate-slide-in-right {
    animation: slideInRight 1s ease-out forwards;
  }
  
  .pulse-animation {
    animation: pulse 2s infinite;
  }
  
  /* Button Styles */
  .btn {
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 14px;
    letter-spacing: 0.5px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  .btn-outline {
    background: transparent;
    border: 2px solid #fff;
    color: #fff;
  }
  
  .btn-outline:hover {
    background: rgba(255, 255, 255, 0.2);
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  
  .btn-solid {
    background: #fff;
    border: 2px solid #fff;
    color: #002446;
  }
  
  .btn-solid:hover {
    background: #f0f0f0;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  
  .btn-large {
    padding: 14px 28px;
    font-size: 16px;
  }
  
  /* Header Styles */
  .header {
    background-color: #002446; /* Midnight Blue */
    color: white;
    padding: 15px 3%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    width: 100%;
    z-index: 100;
    box-sizing: border-box;
    max-width: 100%;
    overflow-x: hidden;
  }
  
  @media (max-width: 992px) {
    .header {
      padding: 12px 2%;
    }
    
    .nav-links {
      gap: 15px;
    }
    
    .site-name {
      font-size: 20px;
    }
  }
  
  @media (max-width: 768px) {
    .header {
      padding: 10px 2%;
      flex-wrap: wrap;
      justify-content: center;
      gap: 10px;
    }
    
    .logo-section {
      margin-right: auto;
    }
    
    .nav-links {
      gap: 10px;
      order: 3;
      width: 100%;
      justify-content: center;
      margin-top: 8px;
    }
    
    .auth-buttons {
      gap: 8px;
      margin-left: auto;
    }
    
    .btn {
      padding: 6px 12px;
      font-size: 14px;
    }
  }
  .logo-section {
    display: flex;
    align-items: center;
    gap: 10px;
  }
  
  .logo {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    transition: transform 0.3s ease;
  }
  
  .logo:hover {
    transform: scale(1.1);
  }
  
  .site-name {
    font-size: 24px;
    font-weight: bold;
    margin: 0;
    background: linear-gradient(45deg, #fff, #cce5ff);
    background-clip: text;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  .nav-links {
    display: flex;
    gap: 20px;
  }
  
  .nav-link {
    color: white;
    text-decoration: none;
    font-size: 16px;
    transition: all 0.3s ease;
    position: relative;
    padding: 5px 0;
    margin: 0 10px;
  }
  
  .nav-link::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 0;
    height: 2px;
    background-color: #fff;
    transition: width 0.3s ease;
  }
  
  .nav-link:hover {
    color: #cce5ff;
    transform: translateY(-2px);
  }
  
  .nav-link:hover::after {
    width: 100%;
  }
  
  .nav-link::before {
    content: '';
    position: absolute;
    top: -5px;
    left: 50%;
    transform: translateX(-50%) scale(0);
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: #fff;
    transition: transform 0.3s ease;
  }
  
  .nav-link:hover::before {
    transform: translateX(-50%) scale(1);
  }
  
  .auth-buttons {
    display: flex;
    gap: 15px;
  }
  
  /* Main Content Styles */
  .main-content {
  flex: 1;
  background: url('../assets/homebackground.jpg') center/cover no-repeat;
  padding: 60px 5%;
  position: relative;
  margin-top: 70px;
}
  
  .main-content::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(to bottom, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.85));
    z-index: 1;
  }
  
  .hero-section {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: center;
    gap: 40px;
    max-width: 1200px;
    margin: 0 auto 60px;
  }
  
  .hero-text {
    flex: 1;
  }
  
  .hero-title {
    font-size: 2.5rem;
    color: #002446;
    margin-bottom: 20px;
    line-height: 1.2;
    font-weight: 700;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
  }
  
  .hero-description {
    font-size: 1.1rem;
    color: #444;
    margin-bottom: 30px;
    line-height: 1.6;
  }
  
  .hero-image {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .btn-primary {
    background: linear-gradient(135deg, #0056b3, #003a75);
    border: none;
    color: white;
    transform: translateY(0);
    box-shadow: 0 4px 15px rgba(0, 86, 179, 0.3);
  }
  
  .btn-primary:hover {
    background: linear-gradient(135deg, #004494, #002c5a);
    transform: translateY(-3px);
    box-shadow: 0 6px 18px rgba(0, 86, 179, 0.4);
  }
  
  .features-section {
    position: relative;
    z-index: 2;
    padding: 40px 5% 80px;
    overflow: visible;
    max-width: 1200px;
    margin: 0 auto;
  }
  
  .section-title {
    text-align: center;
    color: #002446;
    font-size: 32px;
    margin-bottom: 40px;
    position: relative;
    font-weight: 700;
  }
  
  .section-title::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 80px;
    height: 3px;
    background: linear-gradient(90deg, #0056b3, #002446);
  }
  
  /* Testimonials Section Styles */
  .testimonials-section {
    position: relative;
    z-index: 2;
    padding: 60px 5% 80px;
    max-width: 1200px;
    margin: 0 auto;
  }
  
  .testimonials-section .features-carousel {
    margin-top: 40px;
  }
  
  .testimonial-card {
    flex: 0 0 calc(33.333% - 20px);
    min-width: 280px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 36, 70, 0.1);
    padding: 25px;
    transition: all 0.4s ease;
    animation: floatUp 0.8s ease-out forwards;
    opacity: 0;
    transform: translateY(20px);
    animation-delay: calc(var(--i, 0) * 0.2s);
    scroll-snap-align: start;
    margin-right: 10px;
  }
  
  .testimonial-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 15px 35px rgba(0, 36, 70, 0.15);
  }
  
  .testimonial-header {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
  }
  
  .testimonial-avatar {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: linear-gradient(135deg, #0056b3, #002446);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 15px;
    color: white;
    font-size: 24px;
  }
  
  .testimonial-info {
    flex: 1;
  }
  
  .testimonial-name {
    font-size: 18px;
    font-weight: 700;
    color: #002446;
    margin: 0 0 5px 0;
  }
  
  .testimonial-position {
    font-size: 14px;
    color: #666;
    margin: 0;
    font-style: italic;
  }
  
  .testimonial-content {
    position: relative;
  }
  
  .quote-icon {
    color: #0056b3;
    font-size: 24px;
    opacity: 0.3;
    margin-bottom: 10px;
  }
  
  .testimonial-text {
    font-size: 15px;
    line-height: 1.6;
    color: #444;
    margin-bottom: 15px;
  }
  
  .testimonial-rating {
    color: #FFD700;
    font-size: 16px;
    display: flex;
    gap: 2px;
  }
  
  @media (max-width: 992px) {
    .testimonials-container {
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    }
  }
  
  @media (max-width: 768px) {
    .testimonials-container {
      grid-template-columns: 1fr;
    }
    
    .testimonial-card {
      padding: 20px;
    }
  }
  
  .carousel-container {
    max-width: 1200px;
    margin: 0 auto;
    position: relative;
    padding: 0 60px;
  }
  
  .features-carousel {
    display: flex;
    transition: transform 0.5s ease;
    gap: 30px;
    margin-bottom: 30px;
    width: 100%;
    overflow-x: auto;
    position: relative;
    scroll-behavior: smooth;
    scroll-snap-type: x mandatory;
    padding-bottom: 10px; /* For scrollbar space */
    -ms-overflow-style: none;  /* Hide scrollbar for IE and Edge */
    scrollbar-width: none;  /* Hide scrollbar for Firefox */
  }
  
  .features-carousel::-webkit-scrollbar {
    display: none; /* Hide scrollbar for Chrome, Safari and Opera */
  }
  
  .feature-card {
    flex: 0 0 calc(33.333% - 20px); /* Show 3 cards at once with gap */
    min-width: 280px; /* Minimum width for small screens */
    background: white;
    border-radius: 15px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    padding: 30px;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    display: flex;
    flex-direction: column;
    min-height: 350px;
    scroll-snap-align: start;
    overflow-y: auto;
    margin-right: 10px;
    position: relative;
    border: 1px solid rgba(0, 0, 0, 0.05);
    opacity: 0;
    transform: translateY(20px);
  }
  
  .feature-card.animate-on-scroll {
    opacity: 1;
    transform: translateY(0);
  }
  
  .feature-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
    border-color: rgba(0, 86, 179, 0.2);
  }
  
  .feature-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    border-radius: 15px;
    background: linear-gradient(135deg, rgba(0, 86, 179, 0.1), transparent);
    opacity: 0;
    transition: opacity 0.3s ease;
  }
  
  .feature-card:hover::before {
    opacity: 1;
  }
  
  .card-icon {
    font-size: 2.5rem;
    color: #0056b3;
    margin-bottom: 20px;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 60px;
    transition: all 0.3s ease;
    position: relative;
  }
  
  .feature-card:hover .card-icon {
    transform: scale(1.1);
    color: #003a75;
  }
  
  .card-icon::after {
    content: '';
    position: absolute;
    width: 50px;
    height: 50px;
    background: rgba(0, 86, 179, 0.1);
    border-radius: 50%;
    z-index: -1;
    transform: scale(0);
    transition: transform 0.3s ease;
  }
  
  .feature-card:hover .card-icon::after {
    transform: scale(1.5);
  }
  
  .card-content {
    flex: 1;
    display: flex;
    flex-direction: column;
  }
  
  .feature-card h3 {
    color: #002446;
    font-size: 1.5rem;
    margin-bottom: 15px;
    font-weight: 600;
    white-space: normal;
    word-wrap: break-word;
  }
  
  .feature-card p {
    color: #555;
    font-size: 1rem;
    line-height: 1.6;
    margin: 0;
    flex: 1;
    white-space: normal;
    word-wrap: break-word;
    overflow-wrap: break-word;
    hyphens: auto;
  }
  
  .carousel-navigation {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 20px;
  }
  
  .carousel-controls {
    display: flex;
    gap: 15px;
  }
  
  .carousel-indicator {
    display: flex;
    gap: 8px;
    margin-bottom: 20px;
  }
  
  .carousel-indicator span {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: #ccc;
    cursor: pointer;
    transition: all 0.3s ease;
  }
  
  .carousel-indicator span.active {
    background: #0056b3;
    transform: scale(1.2);
  }
  
  .control-btn {
    background: #002446;
    color: white;
    border: none;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
  }
  
  .control-btn:hover {
    background: #0056b3;
    transform: scale(1.1);
  }
  
  .main-image {
    max-width: 100%;
    height: auto;
    max-height: 400px;
    object-fit: contain;
    border-radius: 15px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
  }
  
  /* Footer Styles */
  .footer {
    background-color: #002446;
    color: white;
    padding: 60px 5%;
    display: flex;
    justify-content: space-between;
    gap: 60px;
    position: relative;
    overflow: hidden;
  }
  
  .footer::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #0056b3, #002446, #0056b3);
  }
  
  .footer-section {
    flex: 1;
    animation: fadeIn 1s ease-out forwards;
    position: relative;
    z-index: 1;
  }
  
  .footer-title {
    font-size: 1.5rem;
    margin-bottom: 20px;
    color: white;
    position: relative;
    padding-bottom: 10px;
    font-weight: 600;
    letter-spacing: 0.5px;
  }
  
  .footer-title::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 50px;
    height: 2px;
    background: linear-gradient(90deg, #0056b3, #cce5ff);
    transition: width 0.3s ease;
  }
  
  .footer-section:hover .footer-title::after {
    width: 80px;
  }
  
  .footer-text {
    font-size: 1rem;
    line-height: 1.8;
    opacity: 0.9;
  }
  
  .contact-items {
    display: flex;
    flex-direction: column;
    gap: 15px;
    margin-top: 20px;
  }
  
  .contact-item {
    display: flex;
    align-items: center;
    gap: 15px;
    transition: transform 0.3s ease;
  }
  
  .contact-item:hover {
    transform: translateX(5px);
  }
  
  .contact-item i {
    color: #0056b3;
    font-size: 1.2rem;
    width: 25px;
    height: 25px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    padding: 10px;
    transition: all 0.3s ease;
  }
  
  .contact-item:hover i {
    background-color: rgba(255, 255, 255, 0.2);
    transform: scale(1.1);
  }
  
  .social-icons {
    display: flex;
    gap: 15px;
    margin-top: 20px;
    margin-bottom: 30px;
  }
  
  .social-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.2rem;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
  }
  
  .social-icon::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, #0056b3, #003a75);
    opacity: 0;
    transition: opacity 0.3s ease;
    z-index: -1;
  }
  
  .social-icon:hover {
    transform: translateY(-5px);
    color: white;
  }
  
  .social-icon:hover::before {
    opacity: 1;
  }
  
  .copyright {
    font-size: 0.9rem;
    opacity: 0.7;
    margin-top: 20px;
    text-align: center;
  }
  
  .btn-footer {
    background: linear-gradient(135deg, #0056b3, #003a75);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-top: 20px;
    position: relative;
    overflow: hidden;
  }
  
  .btn-footer::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
    transition: left 0.7s ease;
  }
  
  .btn-footer:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  }
  
  .btn-footer:hover::before {
    left: 100%;
  }
  
  .footer-cta {
    margin-top: 20px;
  }
  
  /* Animation for elements when scrolling */
  .animate-on-scroll {
    animation: fadeInUp 0.8s ease-out forwards;
  }
  
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  /* Enhanced button styles */
  .btn-primary {
    background: linear-gradient(135deg, #0056b3, #003a75);
    border: none;
    color: white;
    transform: translateY(0);
    box-shadow: 0 4px 15px rgba(0, 86, 179, 0.3);
    position: relative;
    overflow: hidden;
    z-index: 1;
  }
  
  .btn-primary::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
    transition: left 0.7s ease;
    z-index: -1;
  }
  
  .btn-primary:hover {
    background: linear-gradient(135deg, #004494, #002c5a);
    transform: translateY(-3px);
    box-shadow: 0 6px 18px rgba(0, 86, 179, 0.4);
  }
  
  .btn-primary:hover::before {
    left: 100%;
  }
  
  .pulse-animation {
    animation: pulse 2s infinite;
  }
  
  /* Responsive adjustments for footer */
  @media (max-width: 768px) {
    .footer {
      flex-direction: column;
      gap: 40px;
      padding: 40px 5%;
    }
    
    .social-icons {
      justify-content: center;
    }
    
    .copyright {
      text-align: center;
    }
  }
  
  @media (max-width: 768px) {
    .hero-section {
      flex-direction: column;
      gap: 30px;
      text-align: center;
    }
  
    .carousel-container {
      padding: 0 20px;
    }
  
    .feature-card {
      min-height: auto;
    }
  
    .footer {
      flex-direction: column;
      gap: 40px;
      padding: 40px 5%;
    }
  
    .nav-links {
      display: none;
    }
  
    .auth-buttons {
      gap: 10px;
    }
  
    .btn {
      padding: 8px 16px;
      font-size: 14px;
    }
  }
  
  </style>

