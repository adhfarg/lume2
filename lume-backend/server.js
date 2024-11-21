const express = require('express');
const multer = require('multer');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });

// In-memory storage for health certifications (replace with a database in production)
let healthCertifications = [];

app.post('/submit-health-certification', upload.single('testResultFile'), (req, res) => {
  const { userId, stdTest, hivTest, covidVaccination } = req.body;
  const testResultFile = req.file;

  if (!testResultFile) {
    return res.status(400).send('No file uploaded.');
  }

  const newCertification = {
    id: Date.now().toString(),
    userId,
    stdTest,
    hivTest,
    covidVaccination,
    testResultFilePath: testResultFile.path,
    verified: false
  };

  healthCertifications.push(newCertification);
  res.json({ success: true, certificationId: newCertification.id });
});

app.get('/health-certification/:userId', (req, res) => {
  const userId = req.params.userId;
  const certification = healthCertifications.find(cert => cert.userId === userId);
  if (certification) {
    res.json(certification);
  } else {
    res.status(404).json({ error: 'Certification not found' });
  }
});

app.post('/verify-health-certification', (req, res) => {
  const { certificationId, doctorId, verified } = req.body;
  const certification = healthCertifications.find(cert => cert.id === certificationId);
  if (certification) {
    certification.verified = verified;
    certification.verifiedBy = doctorId;
    res.json({ success: true });
  } else {
    res.status(404).json({ error: 'Certification not found' });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});