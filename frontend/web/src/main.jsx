import React from 'react';
import {createRoot} from 'react-dom/client';
import App from './App';
import VideoExperience from './VideoExperience';
import {CONTENT_REVEAL_SECONDS} from './video-timing';
import './styles.css';
import './marketplace.css';
createRoot(document.getElementById('root')).render(<VideoExperience revealAt={CONTENT_REVEAL_SECONDS}><App/></VideoExperience>);
