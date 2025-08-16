const translations = {};
let currentLocale = 'en';
const availableLocales = ['de', 'en', 'fr']; // Will be updated dynamically
const localeCache = {};
let isInitialized = false;

const translationEvents = new EventTarget();

async function loadLocale(locale) {
  if (localeCache[locale]) {
    return localeCache[locale];
  }

  try {
    const response = await fetch(`./locales/${locale}.json`);
    if (!response.ok) {
      throw new Error(`Locale ${locale} not found`);
    }
    const data = await response.json();
    localeCache[locale] = data;
    return data;
  } catch (error) {
    console.error(`Failed to load locale ${locale}:`, error);
    return null;
  }
}

async function discoverAvailableLocales() {
  const commonLocales = [
    'de', // German
    'en', // English
    'fr', // French
    'es', // Spanish
    'it', // Italian
    'nl', // Dutch
    'pl', // Polish
    'pt', // Portuguese
    'ru', // Russian
    'tr', // Turkish
    'cs', // Czech
    'sk', // Slovak
    'hu', // Hungarian
    'ro', // Romanian
    'bg', // Bulgarian
    'hr', // Croatian
    'sl', // Slovenian
    'lv', // Latvian
    'lt', // Lithuanian
    'et', // Estonian
    'fi', // Finnish
    'sv', // Swedish
    'da', // Danish
    'no', // Norwegian
    'is', // Icelandic
    'el', // Greek
    'he', // Hebrew
    'ar', // Arabic
    'zh', // Chinese (Simplified)
    'zh-TW', // Chinese (Traditional)
    'ja', // Japanese
    'ko', // Korean
    'th', // Thai
    'vi', // Vietnamese
    'id', // Indonesian
    'ms', // Malay
    'hi', // Hindi
    'bn', // Bengali
    'fa', // Persian
    'uk', // Ukrainian
    'sr', // Serbian
    'sq', // Albanian
    'mk', // Macedonian
    'ka', // Georgian
    'hy', // Armenian
    'az', // Azerbaijani
    'bs', // Bosnian
    'mt', // Maltese
    'ga', // Irish
    'cy', // Welsh
    'eu', // Basque
    'gl', // Galician
    'ca', // Catalan
    'af', // Afrikaans
    'sw', // Swahili
    'zu', // Zulu
    'xh', // Xhosa
    'st', // Southern Sotho
    'tn', // Tswana
    'ts', // Tsonga
    've', // Venda
    'ss', // Swati
    'nr', // South Ndebele
    'nd', // North Ndebele
    'rw', // Kinyarwanda
    'so', // Somali
    'am', // Amharic
    'yo', // Yoruba
    'ig', // Igbo
    'ha', // Hausa
    'fil', // Filipino
    'ta', // Tamil
    'te', // Telugu
    'ml', // Malayalam
    'kn', // Kannada
    'mr', // Marathi
    'gu', // Gujarati
    'pa', // Punjabi
    'ur', // Urdu
    'si', // Sinhala
    'my', // Burmese
    'km', // Khmer
    'lo', // Lao
    'mn', // Mongolian
    'ne', // Nepali
    'ps', // Pashto
    'uz', // Uzbek
    'tk', // Turkmen
    'ky', // Kyrgyz
    'tg', // Tajik
    'kk', // Kazakh
    'be', // Belarusian
    'mo', // Moldovan
    'lb', // Luxembourgish
    'fo', // Faroese
    'sm', // Samoan
    'to', // Tongan
    'fj', // Fijian
    'mg', // Malagasy
    'qu', // Quechua
    'ay', // Aymara
    'gn', // Guarani
    'guw', // Gun
    'se', // Northern Sami (Sweden)
    'sma', // Southern Sami
    'smj', // Lule Sami
    'sms', // Skolt Sami
    'smn', // Inari Sami
  ];
  const discovered = [];

  for (const locale of commonLocales) {
    try {
      const response = await fetch(`./locales/${locale}.json`);
      if (response.ok) {
        discovered.push(locale);
      }
    } catch (error) {
    }
  }

  availableLocales.splice(0, availableLocales.length, ...discovered);
  return discovered;
}

async function initializeTranslations() {
  await discoverAvailableLocales();
  
  let localeToLoad = 'en';
  if (!availableLocales.includes('en') && availableLocales.includes('de')) {
    localeToLoad = 'de';
  } else if (!availableLocales.includes('en') && !availableLocales.includes('de') && availableLocales.length > 0) {
    localeToLoad = availableLocales[0];
  }

  const localeData = await loadLocale(localeToLoad);
  if (localeData) {
    currentLocale = localeToLoad;
    Object.assign(translations, localeData);
    isInitialized = true;
    
    translationEvents.dispatchEvent(new CustomEvent('translationsReady', {
      detail: { locale: currentLocale, translations }
    }));
  }
}

initializeTranslations();

window.addEventListener('message', (event) => {
  if (event.data.action === 'setLocale') {
    setLocale(event.data.locale);
  }
});

async function setLocale(locale) {
  if (!availableLocales.includes(locale)) {
    console.error('Locale not available:', locale, 'Available locales:', availableLocales);
    return false;
  }

  const localeData = await loadLocale(locale);
  if (localeData) {
    currentLocale = locale;
    Object.keys(translations).forEach(key => delete translations[key]);
    Object.assign(translations, localeData);
    
    translationEvents.dispatchEvent(new CustomEvent('translationsChanged', {
      detail: { locale: currentLocale, translations }
    }));
    
    return true;
  }
  return false;
}

window.setLocale = function(locale) {
  return setLocale(locale);
};

window.getAvailableLocales = function() {
  return [...availableLocales];
};

window.getCurrentLocale = function() {
  return currentLocale;
};

window.refreshLocales = async function() {
  await discoverAvailableLocales();
  return availableLocales;
};

window.isTranslationsReady = function() {
  return isInitialized;
};

window.waitForTranslations = function() {
  return new Promise((resolve) => {
    if (isInitialized) {
      resolve(translations);
    } else {
      translationEvents.addEventListener('translationsReady', (event) => {
        resolve(event.detail.translations);
      }, { once: true });
    }
  });
};

export function t(key, params = {}) {
  if (!isInitialized || Object.keys(translations).length === 0) {
    return key;
  }

  let str = key.split('.').reduce((o, i) => (o ? o[i] : key), translations);
  
  if (str === key && !translations[key.split('.')[0]]) {
    return key;
  }

  Object.entries(params).forEach(([k, v]) => {
    str = str.replace(new RegExp(`{${k}}`, 'g'), v);
  });
  
  return str;
}