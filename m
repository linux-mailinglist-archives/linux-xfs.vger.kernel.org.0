Return-Path: <linux-xfs+bounces-30960-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wM6hJMGJlWnqSAIAu9opvQ
	(envelope-from <linux-xfs+bounces-30960-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 10:43:29 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 49FF4154D09
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 10:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3817B303E392
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 09:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD3733CEAF;
	Wed, 18 Feb 2026 09:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3P4P0XG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="llG4ruJ2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B5B33CEBF
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771407798; cv=none; b=O4PK8hKew4InVA7pqed+LkOUxTTUPTFB2lfR5D2FSXjgLEkgJexYMG5jvwsS6NFiyaCU2OKBV+9thLdbj0FREc3pEBDKwBDHn8IyJ69HJB+/YgKGgfP8yG1l9lA1uoYfgpn5EEJoDX+FMHIoqvWOxYzd3q3LVI26ox3tA0qUpSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771407798; c=relaxed/simple;
	bh=7MlMSQiD44nGkm9QdFDfkQrwjXCe6pqty82o5oGxOvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQSJDWJu93LiRvJlU9UPvp9hB2urOQ6pXsGqAGXPYUhwoS3p1aXNvRg7dyfjsKK3GWHYTI+m04Pb25Bxq+QIkOJME3fV/62ib+S87cZ0nfKxuhias/QuCbMNbY4EXZqxh06eJqwex5I06xD/QdYB0DePPV4qwhuOlY6/dSSHa9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3P4P0XG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=llG4ruJ2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771407796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=acxJsX/Fq0LQyGsW9dYw2IB/+V+2/p4bzlJYGYuBU/A=;
	b=e3P4P0XG52eVsf4Cz59RQzrzMnH2c2L+41kP/1z/tbUSSwFdJ7O8iexKWQ0Qo2B5Gm1WXI
	YgCMuqalIvRvvI3TF4BzsUJVcpUrEin8GDHyfH8Io0iICRmrY8wkH59pludsSbPGDT8SsF
	EzUl2Td2AFTgmGm63y95eIKHAZDIy9s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-k0tqBvkWPNOV3KPUWjUzFQ-1; Wed, 18 Feb 2026 04:43:13 -0500
X-MC-Unique: k0tqBvkWPNOV3KPUWjUzFQ-1
X-Mimecast-MFC-AGG-ID: k0tqBvkWPNOV3KPUWjUzFQ_1771407792
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4837b7903f3so45493745e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 01:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771407792; x=1772012592; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=acxJsX/Fq0LQyGsW9dYw2IB/+V+2/p4bzlJYGYuBU/A=;
        b=llG4ruJ2HOStO8LT8TRUUj379Pscpw8QjTukO7zbmZ8g2YO0Ueqv+uA1/sl7LYpk90
         dw5kHWPGc9iN/aenBEvmSMXoanJyOve1c7wwbW2JkqcbXxFdpQMkQusF/99Er5x1l12d
         n3G8dRyEec3+mA25eDGauLTuRiY5fh1rUwS5h7YKEVzbnzGewgq/TXmywjTwuh75zZh4
         zInD1Z0hmYN87vA+19ZlxEAOIhV9qgfLXOpgKwxQNZBDl7NrtgmVu21mzWNa+bDkxvl8
         gwBBaMTgEDcOVUAJ3kzzc2QALHG5kWGYLOLfSeRwx9zuoYAxjW3TLi0Jvc4+wprHgtTG
         XbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771407792; x=1772012592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=acxJsX/Fq0LQyGsW9dYw2IB/+V+2/p4bzlJYGYuBU/A=;
        b=h73UEOSkh4H6XvfcAZUK/jHonglKyK6yP8efBAWU31Kvh6rMqvgyc6E4pOdt0HAPoo
         +CxMsKtoRHEbP39vioVxEejgzYcXaVsJFBR5Q75HSkSUKWiibRojpmQtFtLROxC1QY8z
         hJGmIgY0v5v6peihTxnFPF+A7EfE9jVC59era7bT8I//pCNfNagWRN0O60XjubsiK+f4
         ofl5ErpzURNO9yH40dzvM93vAyJFUFSB/1bHzVd2MuDqq0tWvPR0ozxPEu/7V63Qelsu
         MNLvgVKAzc0bdSJmFXIrUmFXMAEiqtpLsx4spE34x2WedWxK3ZLOKSHsPfX4Z65mK74r
         Jvpg==
X-Forwarded-Encrypted: i=1; AJvYcCX1lUDn0vfb/ZhvtUVbbf6onmBEGyPxB7zR/pWoIzljcssgNVMrxRDwVSl529C1n04IjQxB2kiSkQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdkuPdK9tgXVH89zH5TgeZLM09rjK+9D8egHUaWeQwhQtObXjl
	EWmz3srtQ3VKyiq3uwsbdleBYEKvVFrOd+3n/qpUHdCBPSsQY1HRcJHthlWtxirxWjn0TBlbANU
	FjwtFFmlo0eQ5Rd7brO6CKoLbbUI6AGV+9RNq07UAqPRLcohqwY+F6EbzPnTK
X-Gm-Gg: AZuq6aIqvOyYHuNvxnjtrV0J0+wIGMCDSESgTN3EpufByoeeIRbrMr/bCJJoiFHj/Bh
	7tX1fmZT9/mqJpPOQR2qVBTfbhC4nKAnCavs2PPXqOnVQ4QG/XEbr8NuYcJJxnBZZofvZRSFPs8
	7TRaYHPXmvjU04xNpYa5qxeDkfarQgDPZyKXuXnt7PBy2JA4MRjXEqj0VnIdLWzctX6Xqw3IiF5
	v50iqd/JpTTM5rd8tG7picPFu7GxwHByNcEzATGt36/8Sb6t54ROgWsxILfcSWFBxg6YI/01ab0
	4BFEVojsvPWrSb881WYIAeJg/GavsszRbPOzIZvniSuEql5wLGgYtJs598nSAeFhjadT4wPLI6s
	ixXsK47K4WgI=
X-Received: by 2002:a05:600c:3e0c:b0:477:76c2:49c9 with SMTP id 5b1f17b1804b1-48398a65ecdmr21410095e9.2.1771407791622;
        Wed, 18 Feb 2026 01:43:11 -0800 (PST)
X-Received: by 2002:a05:600c:3e0c:b0:477:76c2:49c9 with SMTP id 5b1f17b1804b1-48398a65ecdmr21409665e9.2.1771407791053;
        Wed, 18 Feb 2026 01:43:11 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abc85csm40263806f8f.22.2026.02.18.01.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 01:43:10 -0800 (PST)
Date: Wed, 18 Feb 2026 10:42:40 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 13/35] xfs: use folio host instead of file struct
Message-ID: <jvxkaf73yuudonjcu2uoazt6yq33ievjo3js43lh4amrwrb5gq@7sj7zzcv2jfl>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-14-aalbersh@kernel.org>
 <20260218063234.GA8600@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218063234.GA8600@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30960-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aalbersh@redhat.com,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 49FF4154D09
X-Rspamd-Action: no action

On 2026-02-18 07:32:34, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 12:19:13AM +0100, Andrey Albershteyn wrote:
> > fsverity will not have file struct in ioend context
> > (fsverity_verify_bio() path). This will cause null pointer dereference
> > here.
> 
> FYI, I've included this and some cosmetic cleanups in the just posted
> updated PI series.
> 

aha, thanks, I will drop this one then

-- 
- Andrey


