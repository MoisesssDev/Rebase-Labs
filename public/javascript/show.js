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
  // Função para gerar o corpo da tabela com base nos dados fornecidos
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
          <h2>${data[0].name} - ${data[0].cpf}</h2>
        </div>
        <p><span>Data de Nascimento:</span> ${data[0].birthday}</p>
      </div>

      <div class="details-doctor">
        <p><span>Médico(a):</span> ${data[0].doctor.name} - ${data[0].doctor.crm}</p>
        <p><span>Estado do CRM -</span> ${data[0].doctor.crm_state}</p>
      </div>

      <div class="details-result">
        <div class="info-result">
          <h3>Resultados:</h3>
          <p><span>Token: </span>${data[0].result_token}</p>
        </div>
        <p><span>Data do resultado:</span> ${data[0].result_date}</p> 
      </div>
    </div>
  `;

  return details
}

function renderTest(data) {
  // Função para renderizar a tabela no DOM
  var title = `<h2><img src="images/note.png" alt="exames"> Resultado do exame:</h2>`;
  var link_back = `<a href="/"><img src="images/left.png">Voltar</a>`;
  var navTest = `<div class="nav-table">${link_back}<div class="nav-table-content">${title}</div></div>`;
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