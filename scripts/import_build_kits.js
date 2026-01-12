// Firebase Admin SDK를 사용하여 빌드업 키트 데이터를 일괄 추가하는 스크립트
// 사용법: node scripts/import_build_kits.js

// 주의: Firebase Admin SDK 설정 필요
// npm install firebase-admin
// 서비스 계정 키 파일 필요

/*
const admin = require('firebase-admin');
const serviceAccount = require('./path/to/serviceAccountKey.json');
const buildKitsData = require('./build_kits_data.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function importBuildKits() {
  try {
    const batch = db.batch();
    
    buildKitsData.forEach((kit, index) => {
      const docRef = db.collection('buildKits').doc();
      batch.set(docRef, kit);
    });
    
    await batch.commit();
    console.log('빌드업 키트 데이터 추가 완료!');
  } catch (error) {
    console.error('오류 발생:', error);
  }
}

importBuildKits();
*/

console.log('이 스크립트를 사용하려면:');
console.log('1. Firebase Admin SDK 설치: npm install firebase-admin');
console.log('2. Firebase Console에서 서비스 계정 키 다운로드');
console.log('3. build_kits_data.json 파일 준비 (31개 키트 데이터)');
console.log('4. 스크립트 주석 해제 및 수정 후 실행');
