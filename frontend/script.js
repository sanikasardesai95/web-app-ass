document.getElementById('dataForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const country = document.getElementById('country').value;
    const value1 = document.getElementById('value1').value;
    const value2 = document.getElementById('value2').value;

    if (!name || !email || !phone || !country || !value1 || !value2) {
        alert('All fields are required!');
        return;
    }

    fetch('http://34.44.23.167:5000/submit', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ name, email, phone, country, value1, value2 })
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        if (data.message) {
            alert(data.message);
        } else if (data.error) {
            alert(data.error);
        }
    })
    .catch(error => console.error('Error:', error));
});
