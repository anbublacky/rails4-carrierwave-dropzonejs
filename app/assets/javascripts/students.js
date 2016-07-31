$(document).ready(function(){
	// disable auto discover
	Dropzone.autoDiscover = false;
	var previewNode = document.querySelector("#template");
	previewNode.id = "";
	var previewTemplate = previewNode.parentNode.innerHTML;
	previewNode.parentNode.removeChild(previewNode);
	// grap our upload form by its id
	$(".dropzone").dropzone({
		// restrict image size to a maximum 1MB
		maxFilesize: 10,
		acceptedFiles: ".jpeg,.jpg,.png,.gif, .pdf",
		// changed the passed param to one accepted by
		// our rails app
		paramName: "student[imagefile]",
		// show remove links on each image upload
		addRemoveLinks: true,
		// if the upload was successful
		previewTemplate: previewTemplate,
		previewsContainer: "#previews", // Define the container to display the previews
		sending: function(file, response){
			console.log('sending------------------------------')
			$( "a:contains('Cancel upload')" ).css( "display", "none" );
		},
		success: function(file, response){
			$.ajax({
				type: 'GET',
				url: '/render-progress-limit',
				data: {student_id: $('#student_student_id').val()},
				success: function(data){
					console.log(data.message);
				}
			});
			// find the remove button link of the uploaded file and give it an id
			// based of the fileID response from the server
			$(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
			// add the dz-success class (the green tick sign)
			$(file.previewElement).addClass("dz-success");
		},
		error: function(file, response){
			$(file.previewTemplate).find('.error').html('File not uploaded, Please check')
		},
		//when the remove button is clicked
		removedfile: function(file){
			// grap the id of the uploaded file we set earlier
			console.log($('.file-row').index(file.previewTemplate))
			var id = $('#student_student_id').val() 
			// make a DELETE ajax request to delete the file
			$.ajax({
				type: 'DELETE',
				url: '/students/' + id,
				data: {image_index: $('.file-row').index(file.previewTemplate)},
				success: function(data){
					console.log(data.message);
					$(file.previewTemplate).remove()
					$.ajax({
						type: 'GET',
						url: '/render-progress-limit',
						data: {student_id: $('#student_student_id').val()},
						success: function(data){
							console.log(data.message);
						}
					});
				}
			});
		}
	});	
});