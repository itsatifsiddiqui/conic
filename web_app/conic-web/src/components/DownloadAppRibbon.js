import React from 'react'
import FileDownload from '@mui/icons-material/FileDownload';
import { Container, Row, Col } from 'react-bootstrap';


export default function DownloadAppRibbon() {
  return (
    <Container >
      <Row>
        <Col>
          <h2 style={{
            // padding: "4px",
            // color: 'whitesmoke',
            // margin: '0px',
            // textAlign: 'center',
          }} >Download App Now</h2>
        </Col>
        <Col>
          <FileDownload fontSize="small" />
        </Col>



      </Row>
    </Container>
    // <Box sx={{
    // bgcolor: 'text.primary',
    // }}>
    // <h2 style={{
    //     padding: "4px",
    //     color: 'whitesmoke',
    //     margin: '0px',
    //     textAlign: 'center',
    // }} >Download App Now</h2>
    // <FileDownload fontSize="small" />

    // </Box>


  );
}
