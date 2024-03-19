Return-Path: <linux-xfs+bounces-5318-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60FBA87FA3B
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Mar 2024 10:00:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD92FB21428
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Mar 2024 09:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1F47D081;
	Tue, 19 Mar 2024 09:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dV5QfVVQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819407D071
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 09:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710838803; cv=none; b=YykqFMTK6rpQwuetAdCVjpT8djcp/1IvWpgTDISSMRvjKC5cnzQe44e1JnDOYXUGl1lFodceemtaYkKMV97api9qf5/DMd67i5zj2P5mC+s/E6cBwuFFNAQ7zp2upG0o0ZqWdJnnHXEiaHCQpWD5XlcAYlyiT1meoziGwKjEzZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710838803; c=relaxed/simple;
	bh=CgA0e+m8BBExrEbwYamwe1j/QwTE5GIpu4sDF98nzT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sLN/mDr25ovEH0l15zMsW730AweEbTYccSXWSxeSuTrclPuKrAckBO1ZgfoBqI8HwmxrLLyWZZU+gvWN5ku8fssX+/QQRzs0MeR/fPuLxgHiGXpdgUyYwfUx3YQW66oIytTM9T2+JMmCkQVhNiAnl9TAijsoHC4rkdplxvsemFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dV5QfVVQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710838800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5BUiLcNn6QrFnn0+/s3dZixFiyFIk9LWlyemfwmVJOQ=;
	b=dV5QfVVQGcOTdWd/mOrC2D6Um2ctFC4OJzYlk6r4AvMIb/MfvC975/DmqzzleRsT6eEQu+
	nwgPIv3/61QUI4LOipMwg4ijP6h7OsaZg1a/dYkjgzVvIfbQeziH8svCaaF8kD6+mzLUr4
	64BnD50jiYQL9Bt0gmKpecQ3cBaGvpk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-OdrfOG5YP5yhK3J-6kKdIw-1; Tue, 19 Mar 2024 04:59:57 -0400
X-MC-Unique: OdrfOG5YP5yhK3J-6kKdIw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33ed2677640so2219393f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 01:59:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710838796; x=1711443596;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5BUiLcNn6QrFnn0+/s3dZixFiyFIk9LWlyemfwmVJOQ=;
        b=g0rr4Fje+HzuFTrIan5MOYvECZSsbeqjKnVg79dDrBD6wsv6DVmFzdCsE+EPV+Me4I
         UMY/H5leFSo8RduNO7Bbn1msPdX+bi7okZyv/21ziMZw+gfXRfrp0HIe83lHLXm9ihNS
         sEiinpE9QypvESKtOsOZve4PzbatoYdxGJ1dJbitJXodjmZOOOtwg2VVKIyjXSQZD519
         /9rdeHmJde+uMwshLM9NBNAJCsLtU+LYMqFIt74alohdYn2uDkkvE57RaFfuXucldR1P
         swRZwLUVzOr3KHNJYB8706k4/982P33BWESx2kFyDN8TD4oo5/igWIGnQapaULjm9G01
         FbEA==
X-Forwarded-Encrypted: i=1; AJvYcCVZZhCkXKq4OCkZ6EiyYRFvM5VoW5EKFTePCDiycRcqN5zABlU/VVI8rX8yaVwbIB2R42QYyMmGbCF4tP4AWWi6YnBayMgxutqv
X-Gm-Message-State: AOJu0Yw2qfO7IlrFf8sfinMrWRtOf6iB4GlihqttdG5IRSw8lxBuCero
	Ztf5ddFjwxhIwa875hRLF84NYkzmeXjElRT+aqhIHz1uyld51dbv8fkmEEjghSjS0N1epkn2f8V
	jOc6d8CHXGhDY8xRnGbO9pIwpwGzgExZmCa8HiCmDQ8KKGqxbY0awkXWQew==
X-Received: by 2002:a5d:4112:0:b0:33e:48f9:169d with SMTP id l18-20020a5d4112000000b0033e48f9169dmr1203195wrp.31.1710838796632;
        Tue, 19 Mar 2024 01:59:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIM4IDI7VXvSvTa0BBGChXMEYTwyRL5BUK1Me/WgRfKde71DR/+U3BeXiu0iUxcOCA442zHw==
X-Received: by 2002:a5d:4112:0:b0:33e:48f9:169d with SMTP id l18-20020a5d4112000000b0033e48f9169dmr1203183wrp.31.1710838796239;
        Tue, 19 Mar 2024 01:59:56 -0700 (PDT)
Received: from ?IPV6:2003:cb:c741:2200:2adc:9a8d:ae91:2e9f? (p200300cbc74122002adc9a8dae912e9f.dip0.t-ipconnect.de. [2003:cb:c741:2200:2adc:9a8d:ae91:2e9f])
        by smtp.gmail.com with ESMTPSA id k4-20020adfe3c4000000b0033e48db23bdsm11838179wrm.100.2024.03.19.01.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 01:59:55 -0700 (PDT)
Message-ID: <615b39c1-a439-4fe2-aa8e-f8721dbb896a@redhat.com>
Date: Tue, 19 Mar 2024 09:59:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] fstests: test MADV_POPULATE_READ with IO errors
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
References: <20240314161300.382526-1-david@redhat.com>
 <20240317165157.GE1927156@frogsfrogsfrogs>
 <20240317165333.GF1927156@frogsfrogsfrogs>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240317165333.GF1927156@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.03.24 17:53, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for "mm/madvise: make
> MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly".
> 
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Thanks for including this test, very helpful!

It's my first time reading fstests code, so I cannot give any feedback 
that would be of a lot of value. Having that said, nothing jumped at me :)

-- 
Cheers,

David / dhildenb


