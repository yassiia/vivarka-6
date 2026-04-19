export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST');
    return res.status(405).json({
      error: { message: 'Method not allowed' }
    });
  }

  try {
    var body = req.body || {};
    var system = body.system;
    var messages = Array.isArray(body.messages) ? body.messages : [];

    if (!process.env.ANTHROPIC_API_KEY) {
      return res.status(500).json({
        error: { message: 'ANTHROPIC_API_KEY manquante dans Vercel.' }
      });
    }

    if (!system || !messages.length) {
      return res.status(400).json({
        error: { message: 'Payload invalide : system et messages sont requis.' }
      });
    }

    var apiResponse = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': process.env.ANTHROPIC_API_KEY,
        'anthropic-version': '2023-06-01'
      },
      body: JSON.stringify({
        model: 'claude-sonnet-4-20250514',
        max_tokens: 800,
        system: system,
        messages: messages
      })
    });

    var raw = await apiResponse.text();
    var data = null;

    try {
      data = raw ? JSON.parse(raw) : null;
    } catch (e) {
      data = {
        error: { message: raw || 'Réponse invalide du serveur Anthropic.' }
      };
    }

    if (!apiResponse.ok) {
      return res.status(apiResponse.status).json(data);
    }

    return res.status(200).json(data);
  } catch (e) {
    return res.status(500).json({
      error: { message: e && e.message ? e.message : 'Erreur serveur.' }
    });
  }
}
