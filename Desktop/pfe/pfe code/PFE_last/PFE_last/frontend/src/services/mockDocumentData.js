/**
 * Données statiques pour les documents (factures et devis)
 */

// Clients statiques
const clients = [
  { id: 1, name: 'Entreprise ABC', email: 'contact@entrepriseabc.com', phone: '01 23 45 67 89', address: '123 Rue Principale, 75001 Paris' },
  { id: 2, name: 'Société XYZ', email: 'info@societe-xyz.fr', phone: '01 98 76 54 32', address: '45 Avenue des Affaires, 69002 Lyon' },
  { id: 3, name: 'Boutique Design', email: 'hello@boutique-design.com', phone: '04 56 78 90 12', address: '8 Place du Commerce, 33000 Bordeaux' },
  { id: 4, name: 'Tech Innovations', email: 'contact@tech-innovations.fr', phone: '03 45 67 89 01', address: '56 Rue de l\'Innovation, 31000 Toulouse' },
  { id: 5, name: 'Café Délices', email: 'info@cafe-delices.fr', phone: '02 34 56 78 90', address: '12 Boulevard Gourmand, 44000 Nantes' }
];

// Statuts possibles pour les factures
const invoiceStatuses = ['draft', 'sent', 'paid', 'overdue', 'cancelled'];

// Statuts possibles pour les devis
const quoteStatuses = ['draft', 'sent', 'accepted', 'rejected', 'expired'];

// Génération de factures statiques
const invoices = [
  {
    id: 1,
    name: 'FACT-2023-001',
    type: 'invoice',
    date: '2023-05-15',
    dueDate: '2023-06-15',
    client: clients[0],
    status: 'paid',
    amount: 1250.50,
    items: [
      { id: 1, description: 'Développement site web', quantity: 1, unitPrice: 1000, total: 1000 },
      { id: 2, description: 'Hébergement annuel', quantity: 1, unitPrice: 250.50, total: 250.50 }
    ],
    notes: 'Paiement à 30 jours',
    paymentMethod: 'Virement bancaire',
    reference: 'PROJ-2023-001'
  },
  {
    id: 2,
    name: 'FACT-2023-002',
    type: 'invoice',
    date: '2023-06-02',
    dueDate: '2023-07-02',
    client: clients[1],
    status: 'sent',
    amount: 3500,
    items: [
      { id: 1, description: 'Refonte identité visuelle', quantity: 1, unitPrice: 2500, total: 2500 },
      { id: 2, description: 'Création logo', quantity: 1, unitPrice: 1000, total: 1000 }
    ],
    notes: 'Paiement à 30 jours',
    paymentMethod: 'Chèque',
    reference: 'PROJ-2023-002'
  },
  {
    id: 3,
    name: 'FACT-2023-003',
    type: 'invoice',
    date: '2023-06-10',
    dueDate: '2023-06-25',
    client: clients[2],
    status: 'overdue',
    amount: 750,
    items: [
      { id: 1, description: 'Maintenance mensuelle', quantity: 3, unitPrice: 250, total: 750 }
    ],
    notes: 'Paiement à 15 jours',
    paymentMethod: 'Carte bancaire',
    reference: 'MAINT-2023-001'
  },
  {
    id: 4,
    name: 'FACT-2023-004',
    type: 'invoice',
    date: '2023-06-20',
    dueDate: '2023-07-20',
    client: clients[3],
    status: 'draft',
    amount: 4800,
    items: [
      { id: 1, description: 'Développement application mobile', quantity: 1, unitPrice: 4500, total: 4500 },
      { id: 2, description: 'Publication sur les stores', quantity: 1, unitPrice: 300, total: 300 }
    ],
    notes: 'Paiement à 30 jours',
    paymentMethod: 'Virement bancaire',
    reference: 'APP-2023-001'
  },
  {
    id: 5,
    name: 'FACT-2023-005',
    type: 'invoice',
    date: '2023-05-05',
    dueDate: '2023-06-05',
    client: clients[4],
    status: 'cancelled',
    amount: 1800,
    items: [
      { id: 1, description: 'Campagne publicitaire', quantity: 1, unitPrice: 1800, total: 1800 }
    ],
    notes: 'Annulée suite à la demande du client',
    paymentMethod: 'Virement bancaire',
    reference: 'PUB-2023-001'
  }
];

// Génération de devis statiques
const quotes = [
  {
    id: 6,
    name: 'DEV-2023-001',
    type: 'quote',
    date: '2023-06-01',
    validUntil: '2023-07-01',
    client: clients[0],
    status: 'accepted',
    amount: 5600,
    items: [
      { id: 1, description: 'Développement e-commerce', quantity: 1, unitPrice: 4500, total: 4500 },
      { id: 2, description: 'Formation utilisateurs', quantity: 2, unitPrice: 550, total: 1100 }
    ],
    notes: 'Valable 30 jours',
    reference: 'ECOM-2023-001'
  },
  {
    id: 7,
    name: 'DEV-2023-002',
    type: 'quote',
    date: '2023-06-05',
    validUntil: '2023-07-05',
    client: clients[1],
    status: 'sent',
    amount: 2300,
    items: [
      { id: 1, description: 'Audit SEO', quantity: 1, unitPrice: 1200, total: 1200 },
      { id: 2, description: 'Optimisation technique', quantity: 1, unitPrice: 1100, total: 1100 }
    ],
    notes: 'Valable 30 jours',
    reference: 'SEO-2023-001'
  },
  {
    id: 8,
    name: 'DEV-2023-003',
    type: 'quote',
    date: '2023-05-20',
    validUntil: '2023-06-20',
    client: clients[2],
    status: 'expired',
    amount: 3200,
    items: [
      { id: 1, description: 'Refonte site vitrine', quantity: 1, unitPrice: 3200, total: 3200 }
    ],
    notes: 'Valable 30 jours',
    reference: 'WEB-2023-001'
  },
  {
    id: 9,
    name: 'DEV-2023-004',
    type: 'quote',
    date: '2023-06-15',
    validUntil: '2023-07-15',
    client: clients[3],
    status: 'draft',
    amount: 7500,
    items: [
      { id: 1, description: 'Développement CRM sur mesure', quantity: 1, unitPrice: 7500, total: 7500 }
    ],
    notes: 'Valable 30 jours',
    reference: 'CRM-2023-001'
  },
  {
    id: 10,
    name: 'DEV-2023-005',
    type: 'quote',
    date: '2023-06-10',
    validUntil: '2023-07-10',
    client: clients[4],
    status: 'rejected',
    amount: 950,
    items: [
      { id: 1, description: 'Création newsletter', quantity: 1, unitPrice: 450, total: 450 },
      { id: 2, description: 'Intégration CRM', quantity: 1, unitPrice: 500, total: 500 }
    ],
    notes: 'Refusé car budget client insuffisant',
    reference: 'NEWS-2023-001'
  }
];

// Tous les documents
const allDocuments = [...invoices, ...quotes];

export { clients, invoiceStatuses, quoteStatuses, invoices, quotes, allDocuments };