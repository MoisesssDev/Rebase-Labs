function fetchData(callback) {
  let param = window.location.pathname.split('/');
  let token = param[1];

  var apiUrl = '/api/v1/tests/' + token;

  fetch(apiUrl)
    .then(response => {
      if (!response.ok) {
        throw new Error('Erro na requisição: ' + response.statusText);
      }
      return response.json();
    })
    .then(data => callback(data))
    .catch(error => {
      console.error('Erro:', error);
    });
}

function generateTableBody(data) {
  return data[0]['tests'].map(item => `
    <tr>
      <td>${item.type}</td>
      <td>${item.limits}</td>
      <td>${item.result}</td>
    </tr>
  `).join('');
}

function createTable(data) {

  var tableHeader = `
    <thead>
      <tr>
        <th>Exame</th>
        <th>Limites</th>
        <th>Resultado</th>
      </tr>
    </thead>
  `;

  var tableBody = `
    <tbody>
      ${generateTableBody(data)}
    </tbody>
  `;

  return `<div id="table-container"><table>${tableHeader}${tableBody}</table></div>`;
}


function generateDetailsTest(data) {
  var details = `
    <div class="details">
      <div class="details-patient">
        <div class="info">
          <p> ${data[0].email}</p>
          <h2>${data[0].name}</h2>
          <p class="cpf"><span>CPF:</span> ${data[0].cpf}</p>
        </div>
        <p><span>Data de Nascimento:</span> ${data[0].birthday}</p>
      </div>

      <div class="details-doctor">
        <div class="info-doctor">
          <p><span>Médico(a) responsável:</span> ${data[0].doctor.name}</p>
          <p><span>CRM:</span> ${data[0].doctor.crm}</p>
        </div>
        <p><span>Estado do CRM -</span> ${data[0].doctor.crm_state}</p>
      </div>

      <div class="details-result">
        <div class="info-result">
          <p><span>Token: </span>${data[0].result_token}</p>
          <h3>Resultados:</h3>
        </div>
        <p><span>Data do resultado:</span> ${data[0].result_date}</p> 
      </div>
    </div>
  `;

  return details
}

function renderTest(data) {
  var title = `<h2><img src="images/note.png" alt="exames"> Detalhes do exame:</h2>`;
  var link_back = `<a href="/"><img src="images/left.png">Voltar</a>`;
  var navTest = `<div class="nav-test">${link_back}<div class="nav-test-content">${title}</div></div>`;
  var details = generateDetailsTest(data);
  var table = createTable(data);

  document.getElementById('test-container').innerHTML = `${navTest}<div class="container">${details}${table}</div>`;
}

document.addEventListener('DOMContentLoaded', function() {
  fetchData(data => {
    console.log(data);
    renderTest(data);
  });
});