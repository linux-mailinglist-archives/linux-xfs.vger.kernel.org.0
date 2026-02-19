Return-Path: <linux-xfs+bounces-31112-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJVRC4Q+l2lXwAIAu9opvQ
	(envelope-from <linux-xfs+bounces-31112-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 17:47:00 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B883160C67
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 17:46:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F1CEC30015A8
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 16:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE76F324B10;
	Thu, 19 Feb 2026 16:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ae15TwLB"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F942868B5
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771519614; cv=none; b=Bi8jxKwjSDvc4mz1Wex1lQhGacSb9Sl+yNRyLiasyzEkqS99aSy/vCfa3wbgM+9aQqePDbM7xuBjlAOeJ09us40KW7/xApmANnY3LLHlFwfgSYaiKv7M27As/LG5vmnlyU6UUSB6/yu8rUOtYRmCNPq5I7raS8bmGdGjwuYK7j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771519614; c=relaxed/simple;
	bh=AMXkrxtqo0+dlZrh+Ijb3BN3wZ2bsz6l9G5kEW7xnbs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=PSZXtXuBQUQr2Yo9N31cJxkXDvzaviEho/Nu/DgwL9wENdsv9nwD5VV6wdKJkpYPrKnLyU4sz73a4PLtqveCQ5xT9buAUnZu3itItxihneAk5UgLgUBVYQkq3JMbrT9F3JC4oULsIXJccg+U4ck+NJr3umlf/pLLYTiG7KizLtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ae15TwLB; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-797d509a2f5so13326247b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 08:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771519613; x=1772124413; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMXkrxtqo0+dlZrh+Ijb3BN3wZ2bsz6l9G5kEW7xnbs=;
        b=ae15TwLBuKpUomjZq1iSV1YdU3utCdF2zKVvaxl/tfa484bl0KvCzZid4hHeCoS6/V
         lqFfoHHRb1oUCXJ3EEpvq/AjkObA94ALDW2py57QizEauAyGxRwzNibXYyqaYD70l6/1
         YnC+meJ/gs/JidFuYW2Bm5fTfg872Hv8ygtj1UBSOuko3saCVoPok8l9VV9S9Vylqfxz
         XM7woxrsrG9wfXsG2SGnUtfVYB+N+oqN8KJRsoFYy8cq7Da4qX2DtYIME8FdJz9QTmzm
         T9e0rK9zim9DafBN/+33UjdBJCF2c8q+A2XZxJHZBGQk9O62nQkX74kMBPJslxuqzSk7
         Fxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771519613; x=1772124413;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AMXkrxtqo0+dlZrh+Ijb3BN3wZ2bsz6l9G5kEW7xnbs=;
        b=Hwr5DMUN072DlED+pCUawDhdRKrwHLoiOLkBqeK8gaF7qiBmSGfpEjpE1Gcvm4dDAS
         G7u7FvTZclVNd0vVE96pWw9dqARHegdCITAwrLFhfxvuyyr/+iI8OdhXoE8KCNBgpqZB
         dPS3b/J3rkJoTnVa4CsWknVb8FXap0Bdww2AqcW7/1x/I1ehABDRs1/qCqXMvw4DsESR
         m2JX7cGnTPci0OFsJbpwSYTfpAmWD+W6pMLUgZDqodOEQtERsPXVo0d3erefo3PiLtbP
         p5N7D7vz01MN/5BZ2tTBtdQ2bQjVr00j8XRta8hFqzyF9cJJ0NcW6CzHpSgzSe5Hilsx
         nRPA==
X-Forwarded-Encrypted: i=1; AJvYcCX/7zV3TCTahlnEr+TDNWZvu3oXCfbPh3dfGt6sTgCYC0T7j5Hs4LKR+iil5/gIXgz4KJaLZZjQdoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjTunhKVlPiwsb3LkvBXWN9dW/dUqAs+7pJ2ZALKJPQnZII66n
	zmabsL733rjzYLTXRD5wB7vXON1DJ56GGfAEUAPhk+rftdOmaMtnEmqD
X-Gm-Gg: AZuq6aLK5HSuwlCBld2i4LVpIffCm4xcCgTgeN80qQyrdAvquUhXIUeuC6+ANwjK/KU
	jro2YrZS2yHBf5ERzIObmPN3DVvOfWzoYh9xo+gR8Dg4ZleZsfqP8R5/SoodtrC2UEL1haOHl/5
	IFCu5aPr3UdRkorktY21gOSD2dOSzaxm6t8vPYuq7lg5rQiVAfKPaF8Nls0/n0W8ybRuDMho4gh
	Z7EiYc9Lka3fL6YqN6yzaer545O5KQvTEO29elDdmyikP2aQ+qImC7hG1YKeZ4x+u5YJXmPHnrT
	ea027RpoqRTGpjm7XITjqaaa9g9Qvnls/0cjy3+/MyzgI1NenHB/5rIEPo2yc6dlVt6IQGKOlKT
	9ySep2xLjJxk73IMOpWs9EIaeJiK4WOwWWY7/YKAgORxuwFR0kNLbsqOYqYCLKsFlNBbgt15uOo
	IWhTZ9gj7HraI77q15CyH443jWFK8irZXiMS5ctI1hbII52BpC35vSHwdJ4YhHWQWQnENqoXeur
	ASBz8CZp4UJMq3ztbocXGllMMfW08qlNT3j1DP4s1+IIwzFOTxXiFy8iBshGwMaRIM=
X-Received: by 2002:a05:690c:6e0a:b0:797:d386:44e4 with SMTP id 00721157ae682-797f71e402amr54351877b3.16.1771519612413;
        Thu, 19 Feb 2026 08:46:52 -0800 (PST)
Received: from localhost ([2601:7c0:c37c:4c00:5c8f:3752:85c2:a587])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c254d4esm131010867b3.40.2026.02.19.08.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 08:46:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Feb 2026 10:46:51 -0600
Message-Id: <DGJ3AIJ080KO.3MUES6EQ1TWDA@gmail.com>
Cc: "Christian Brauner" <brauner@kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Fix error pointer dereference
From: "Ethan Tidmore" <ethantidmore06@gmail.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>, "Ethan Tidmore"
 <ethantidmore06@gmail.com>, "Carlos Maiolino" <cem@kernel.org>, "NeilBrown"
 <neil@brown.name>
X-Mailer: aerc 0.21.0
References: <20260218195115.14049-1-ethantidmore06@gmail.com>
 <61386abf00c817e65ab70c994ed584fde339f9ed.camel@gmail.com>
In-Reply-To: <61386abf00c817e65ab70c994ed584fde339f9ed.camel@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31112-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,brown.name];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ethantidmore06@gmail.com,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2B883160C67
X-Rspamd-Action: no action

On Thu Feb 19, 2026 at 5:26 AM CST, Nirjhar Roy (IBM) wrote:
> On Wed, 2026-02-18 at 13:51 -0600, Ethan Tidmore wrote:

...

>
> Based on my limited knowledge of this change looks okay to me. I looked i=
nto the return values of
> try_lookup_noperm() and it does return error pointer which is not NULL. I=
 also checked the other
> call sites of try_lookup_noperm() but I do see a mixed handling i.e, some=
 places just checks for
> !ptr and some for IS_ERR_OR_NULL. For example in fs/autofs it checks with=
 IS_ERR_OR_NULL whereas in
> fs/proc/base.c it just checks for !child. However, IMO, it is better to c=
heck for both NULL and
> error pointer if there is a possibility for both.
> --NR

I was already planning on sending a patch to fs/proc/base.c also. Smatch
was complaining there too.

Thanks,

ET

