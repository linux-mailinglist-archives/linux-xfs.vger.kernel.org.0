Return-Path: <linux-xfs+bounces-6361-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A64E89E6C9
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 02:24:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74569B225A5
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 00:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00447623;
	Wed, 10 Apr 2024 00:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MvNpFUe0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66765372
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708632; cv=none; b=j9bldnYEBeyAVFnOroU+BYdQb78D8kXCi6SuzlRJ0ivuJYcRmRrQngPwS3o5slEW56aqJZBEo7CCpwLbSOSxzcV37RwnymwGwpcWWLGqTTV2AdiHffTq3qoNQM2oCoqm+++7hSw020eHt3RQD9MjUoFO1VsXwEvuVTZYGdb/EF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708632; c=relaxed/simple;
	bh=M8wkmy0FFgNfHoZTlccX2cdK1u7Ho1Ghmzrr/SjCsVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cJQx4oqPs4q6VIBz0kDD500FPOhFPnN/QQYvx8JRsNGk2TGZoG8BtJoOoY1PhMsOzQxms/pSQ6SfruMjIJTQcekW3GIslzTAmsHXtLT4LeOTLZ8Rsl5QWZHQFNsw2OTVT4cvZmRtRrN+VfnX5VnAx6iZqhUK5HNezeFIWiPQ4N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MvNpFUe0; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a5199906493so620292466b.1
        for <linux-xfs@vger.kernel.org>; Tue, 09 Apr 2024 17:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708629; x=1713313429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5KEFu9ntLir/zrgNKi0L8qnCsTF4mTHACifp8EqEFM=;
        b=MvNpFUe0FCz6ls7M7cj/Uzg54G8xdBa8xZY+m5Kzw1WGuA3ivIW+Qky4tuJWW8dSHN
         LFVoYO+TcdCElkMeOM1DEdFOGVCybNffVVae6Q8wCrqzS//dk/k0rKwd6XAXcy6IFYxk
         xEn4ohLovbF0LWKLQMnlHq7GvdJ1IrFLEkH7dKsRZncEooNixBZl/cTCgpLIulChTjkk
         9J/61Ss3t4BzIo/FM9Q4Z8w+83qIQHzXTT97w8XzBbkx4uxyTDHmCAVvQlRbKa59raJj
         AGxyp9474vVvaciCripYZmOObZwbmlsIpypTxi3vBmhDfMc+UuDUVnFGDIBMhDo7Sj87
         uFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708629; x=1713313429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f5KEFu9ntLir/zrgNKi0L8qnCsTF4mTHACifp8EqEFM=;
        b=P+BPDUgF2loW5OfPhVVs8/jjHhKxa+vJpG8YL2GmggMGacPJIIqbbov7j4nbvH7CJK
         FeY1CDLX1UozOt/H1YoHBdTW+RDh6qM5jqjL7QhC54u69TInG/IMp5cf5HNFZiK0DLtm
         mQZDyM9OIp2dv0P4pIBsUAnvVaqiK9fq/+FSzaORJOn8BCafVZWschbRnH4snvICgj2v
         /wkd1s5ZbCpeV5xFEckAqaiRbCM4mcoPLtGTcGqoXf0ggwmWtHfgth/xvQiuZsq5RBtP
         fGy9ATTCJKSGoYGGicxU6RR8jNUOLsKxzRXKuoEOUu+p8Smu8dH2PIb/4uGgvzSek8km
         xowg==
X-Forwarded-Encrypted: i=1; AJvYcCU+vhdRng/FKzoiDzDaddxz3qUx1FPXeTDce2RkU8TJAA8eGR33cOS/bG84PAB5zvAiz54Ix/G/JLqcLcB0LR4u7iGx9a6DsEY+
X-Gm-Message-State: AOJu0YwtScpacUUrOEEomKuniqLNMtdyfVv2Vrt8RnpqzM/IDBLR4Nb1
	Yhb+UQXA3Kc+YDY0FfXyLC42sZH5Rg+hYbjbJ1dfOfjF3yfx+iiyCVJGSnXC5pjF/ykxqiBnVU8
	qjIiY7k9EUpVWFgfPvqhmlAM+7l3WszOmfwA0
X-Google-Smtp-Source: AGHT+IFBzm/AwEpDdiqpg/CwCa4Zosq++tdfYX+7w+FZxqMgXJS+wj0rsmwie4JV2eEKEwKYWPqGyghjmhNvA5np5Qo=
X-Received: by 2002:a17:907:7da5:b0:a52:40c:7cd2 with SMTP id
 oz37-20020a1709077da500b00a52040c7cd2mr758664ejc.66.1712708628590; Tue, 09
 Apr 2024 17:23:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240405-strncpy-xattr-split2-v1-1-90ab18232407@google.com> <ZhVDgbRoF9X7JSdt@infradead.org>
In-Reply-To: <ZhVDgbRoF9X7JSdt@infradead.org>
From: Justin Stitt <justinstitt@google.com>
Date: Tue, 9 Apr 2024 17:23:35 -0700
Message-ID: <CAFhGd8pwoBSvLDRLX8ekRk+u9uX6s6mcAfTz8E15E6EBsvuSag@mail.gmail.com>
Subject: Re: [PATCH] xfs: xattr: replace strncpy and check for truncation
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 9, 2024 at 6:32=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Fri, Apr 05, 2024 at 07:45:08PM +0000, Justin Stitt wrote:
> > -     memcpy(offset, prefix, prefix_len);
> > -     offset +=3D prefix_len;
> > -     strncpy(offset, (char *)name, namelen);                 /* real n=
ame */
> > -     offset +=3D namelen;
> > -     *offset =3D '\0';
> > +
> > +     combined_len =3D prefix_len + namelen;
> > +
> > +     /* plus one byte for \0 */
> > +     actual_len =3D scnprintf(offset, combined_len + 1, "%s%s", prefix=
, name);
> > +
> > +     if (actual_len < combined_len)
>
> Shouldn't this be a !=3D ?

I guess it could be. It's a truncation check so I figured just
checking if the amount of bytes actually copied was less than the
total would suffice.

>
> That being said I think this is actually wrong - the attr names are
> not NULL-terminated on disk, which is why we have the explicit
> zero terminataion above.

Gotcha, in which case we could use the "%.*s" format specifier which
allows for a length argument. Does something like this look better?

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 364104e1b38a..1b7e886e0f29 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -206,6 +206,7 @@ __xfs_xattr_put_listent(
 {
  char *offset;
  int arraytop;
+ size_t combined_len, actual_len;

  if (context->count < 0 || context->seen_enough)
  return;
@@ -220,11 +221,16 @@ __xfs_xattr_put_listent(
  return;
  }
  offset =3D context->buffer + context->count;
- memcpy(offset, prefix, prefix_len);
- offset +=3D prefix_len;
- strncpy(offset, (char *)name, namelen); /* real name */
- offset +=3D namelen;
- *offset =3D '\0';
+
+ combined_len =3D prefix_len + namelen;
+
+ /* plus one byte for \0 */
+ actual_len =3D scnprintf(offset, combined_len + 1, "%.*s%.*s",
+        prefix_len, prefix, namelen, name);
+
+ if (actual_len < combined_len)
+ xfs_warn(context->dp->i_mount,
+ "cannot completely copy context buffer resulting in truncation");

 compute_size:
  context->count +=3D prefix_len + namelen + 1;
---



>
> How was this tested?

With https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/about/

but using scripts + image from: https://github.com/tytso/xfstests-bld

here's the output log: https://pastebin.com/V2gFhbNZ wherein I ran the
5 default ones (I think?):

|        Ran: generic/475 generic/476 generic/521 generic/522 generic/642
|        Passed all 5 tests

Thanks
Justin

