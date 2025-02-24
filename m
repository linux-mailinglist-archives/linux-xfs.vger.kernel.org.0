Return-Path: <linux-xfs+bounces-20104-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90368A42727
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2025 17:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B42A63BE29C
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2025 15:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44B2233714;
	Mon, 24 Feb 2025 15:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="mgOFLmbP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243BF19CC08
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740412395; cv=none; b=fL27S6cuZhP7mChRinZPydnTkqPtJdl6SCNeTPLFdVU30qJW5Oc+jk4oEOI/MgwptNDGPvwkFdONTUwfLD81dPG+Ci1AEf0FKV6nvIkfgnBjrrTORxjIg6pjn5oawyCFOTNQ97mSndirc5QHgrcRjMCl22kVe7u7soqAlEoIdSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740412395; c=relaxed/simple;
	bh=uYb2SdR+XjED6l2vwiNXxNeoIQOwpomZpCV/miLW6OI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jf1gWZ1kPK0Pzf8vry4IlY6ktDdw7sATpvr/P02Hc+rebx4xge/q8AfDaPrDOW+MSI2yF6Hevp8WquVOCr9JGJpo8XG21gPcKCPjCObkqrjG61xvI3MQ51aUmpu2Jx+IHZ3z8FURi4KowhZkRb84w2piPXlWAfqh+u95veGIHrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=mgOFLmbP; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fcce9bb0ecso8996587a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 07:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1740412393; x=1741017193; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klSee0+9neLh/O+vcsAj+EUBQ1CcxR/LJT3Y630rmY8=;
        b=mgOFLmbPBM8r1zZ00oMuK9L1Yt3KX1QEJTWk1NVEy13PY9TI95yA+OWBIjQu00hsWV
         qjZ2S10eekUP6Ew4mAJmBBWEgsk9DPMn5+e2sH1mB0PMr3RUtxj54h+IKEX1uM1dzTIp
         u7RSdKJ9yiYXEQcw2+mGUlZd6u1IXkgrUn1uB403arGYi42pDCPW/zsF1hba7okzNRFk
         GTmNH7D061GEKxhyL/V7XK2e6OMauaFleg3PQh00LSAaDeMayB94bmC8u+tTju9nVm0i
         rS1f214Z3dBL6PRhDaNm8yaDuzes0UbxP8Eqj/t8B1c8zuURuUbMFloi0aQ6IfN8e9Qr
         dwbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740412393; x=1741017193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=klSee0+9neLh/O+vcsAj+EUBQ1CcxR/LJT3Y630rmY8=;
        b=iC+oWW41UkfI5sevueKO1rtgyLNukUX1BfiPocDe7XIqj5pmrQjarbwelU95rWS8wm
         M+VWBV8JqsFfGLLbgajIUPsWI4DnAMSK6BUeNsGw2CjpbGh2zT8Qjcv/gCoMokQh1xkq
         woPX0wdnv8GKrgirR1w2OuaAnwGpU5BqScCREsY76hzjJX8m0J6lZpuhxA0jdpohc+qI
         S9D6hLH6LuaG1xtGyWDRgbng4chBMVhebbswiMa1EQHPgftjVV7uE2SKtCyECsIxKPX4
         juzFwUe9+HA4NLfEj5KzAF8ER8C2kmZVz4rHuaEpXvAz+1dUrbR9s1Djx/tZfTeLvYmK
         vxlg==
X-Forwarded-Encrypted: i=1; AJvYcCXvDNk1sphbiB9hUe8QWZjwj5LSj/Bs1/RVhWodrUZswyseONEBb1tQTjbJqIbHdhB2ppY0S7ZUrYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGmiD8SF8cXuzQNrbdin6Fy4lc6naSCrrU2xvROrsXt4tvV7Ga
	bIp+SeuDYIqSM3P0/C8OBzxob1+Cpu7JwAW3rDMtrhIFH4vmqheHR1yP0Gxwf6Gsh3KmJJvD5we
	86mGPT2R4pErfHYtniuqK+vsbc5prIdPcEKf80Ea9EPHmBnf8eMXMr0DWeu8MycnZCp4OcSw4sp
	907do2Bn6wch18qUoHDZFCmj/cmkf9nYn3G+W7Vq+4N7Lw5hUnPR3k4Mk2yaMcpXZAPDjyHI3lA
	sHXmkpBqDSu9qJcl0uosHXwyT0Ey6yUnjv2MYl8u8cDY4m2Y8EvMgaZPABA7xxEk8PN/MobV2PS
	foLzTHUU2CJSiDIe86QJ1aovuqw3HmveI4TCBOl//w7h1F2cEQdNAchrWcJA6UPQwlEmxSpIA54
	5PJtRtSHl
X-Gm-Gg: ASbGncvvkNGs1wA8ARVtIxM1tPmKPs6xgqbBIzIKd5rCliUZ+7Yadl44QIntc1tyS8s
	TCrXldAZ+eSjBQqxpTgt1Pj7DHJiQo6KzKe/8w6s8hTdI22Vu42T7YOwyHVVLIJ3etKp1C3thNk
	Xyo2Ya7gDho568EKOszG4SMA==
X-Google-Smtp-Source: AGHT+IHGE2C3it+MkWdE5/3EIhsU0uJaSmbSOYkJ0M0osQn818HqOwYmz0ZERxOz4BJpJCZKkMY4BzhOWCJ0JXJcC2Y=
X-Received: by 2002:a17:90b:2e44:b0:2f5:63a:44f9 with SMTP id
 98e67ed59e1d1-2fce7b0acaamr19760932a91.23.1740412393194; Mon, 24 Feb 2025
 07:53:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224081328.18090-1-raphaelsc@scylladb.com>
 <20250224141744.GA1088@lst.de> <Z7yRSe-nkfMz4TS2@casper.infradead.org>
 <CAKhLTr1s9t5xThJ10N9Wgd_M0RLTiy5gecvd1W6gok3q1m4Fiw@mail.gmail.com>
 <Z7yVB0w7YoY_DrNz@casper.infradead.org> <CAKhLTr26AEbwyTrTgw0GF4_FSxfKC2rdJ79vsAwqwrWG8bakwg@mail.gmail.com>
 <Z7yVnlkJx23JbBmG@casper.infradead.org>
In-Reply-To: <Z7yVnlkJx23JbBmG@casper.infradead.org>
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Date: Mon, 24 Feb 2025 12:52:56 -0300
X-Gm-Features: AWEUYZkpULmB7ggdWZq0vQLW6dT8AZhCNwNVQSj2mIp6VwfSCWyVNpmgUWs2yvk
Message-ID: <CAKhLTr2tNHimdu+QeMq=qu4n+K+VyW4PcZdB_nusaW9NSUBG3Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix error handling in __filemap_get_folio() with FGP_NOWAIT
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, 
	Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylla,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Mon, Feb 24, 2025 at 12:51=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Mon, Feb 24, 2025 at 12:50:48PM -0300, Raphael S. Carvalho wrote:
> > Ok, so I will proceed with v4 now, removing the comment.
>
> No.  Give Christoph 24 hours to respond.

I am still getting used to linux development rules / culture. Sure.

