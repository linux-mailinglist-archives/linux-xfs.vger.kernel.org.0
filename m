Return-Path: <linux-xfs+bounces-15267-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 144679C49A8
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 00:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21F2DB260C6
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Nov 2024 23:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC491AC884;
	Mon, 11 Nov 2024 23:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBMEKcGh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA35D175D48
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 23:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731367350; cv=none; b=rKD+J66skN7+glRtoXTY9004cPqmDpxR1ALet2Q9l+cq25gOmtfandULOSZUTEREqzc0kIKS2C965QZ0qfXL8KveV+IHVl+1psHLX+QaIeJJcF+xenYM4X4vQYskM+5rMHAt1SQzqq8qsNJrwq+of3pWrm+O/TeKf5+FX+q4gLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731367350; c=relaxed/simple;
	bh=EtxwPR0tA+NlqpDMqQlCSPRA15HO97jQJTZ+44S4bAc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lrJ/UkeT/qRLsdPjhQIOmhZLtBe45c6d8SZJjzqirX174jRsO07FNgehI3F2GkP451pywp6GVRx0KaGuEb2/WPewc4FZqaiWyvHl+p7uYlC1XhT7Ehs2mOU5MMyV50HB3at5Py1qtAdLOO1I8iaCR7vNky6KPEXwDivyx7qrSUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBMEKcGh; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a99ebb390a5so1117403566b.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731367346; x=1731972146; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h41PWFUhZXsqfSkhC339YBBpzats9vibuE7sqIlzgCc=;
        b=IBMEKcGhjYexP/gRFNQbZKK8aft9F1v23d52aXjPLf+qw2G19aD6wc91+VcKFLIxxb
         6GGRJbiIdLMlhfJ55dALhXOgOP0SBjEtXZFfg61AjUC/B2fflLc6u9ABqRCjuC36VWMN
         5pjqXOwZppDaA4wcwSB3kctsqwoXMnavaqzHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731367346; x=1731972146;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h41PWFUhZXsqfSkhC339YBBpzats9vibuE7sqIlzgCc=;
        b=HsgwipGuisUQtsCY6gEimtvzuVuPuO+Kf/FP5gqjOaA9RMM2NDvMzG4OQzs2tjWPpQ
         JfBvMQx4z8wTeOfRK4tO9+wNEhBARNPNuiBKmeCIQBIG+43uQ7gzsjzWX23KtSjLqVin
         3MrRLZf8eCC4lcmddmdje3JUBIkDMI26ki1chrMRDT+iKtMb9aLG/i9DCUBNC5sBFDW+
         YJ8BpaZixK748TsR65FWX2o8LPnWpf8ffhGeKqplTrHRt5PZTAYJGpO2SMPZVg5hqJdw
         NX/Ahrq6b4UdwtTRZMi4bl6aJy6zu+2VCDK9/Xm4wHTSEjg06ILTRPrPvEK0t+yQXXGi
         wEaA==
X-Forwarded-Encrypted: i=1; AJvYcCUukBEhYbX+96npX9fKZ5l+1HsN3BoHw0UPcD0Kpw5rxW0mGDK42lcNxrEcJFIwYCIO4os7BT454KE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlQ3ZvC5Zn8lUYuyhr1lxGbqRIT2Xk/y2DVvBA9cMatP8U2Dfp
	7Z9uh8sCjfsBu9HKB0wqFtXE96J2LR/dmlDcHwIYOurvy71atxARdBoUtwCUdDs6CV+bUvdC2y9
	xQdk=
X-Google-Smtp-Source: AGHT+IEciNYPYlXL2j4Pjy65CXdPhNmLVtoaa0IS+7IxA7FHDrKA/e5eAVK7zcLq7Grvl2enk/Wkmw==
X-Received: by 2002:a17:906:ee8c:b0:a93:a664:a23f with SMTP id a640c23a62f3a-a9eefe3f3famr1351857166b.5.1731367345781;
        Mon, 11 Nov 2024 15:22:25 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0df39f8sm636215866b.170.2024.11.11.15.22.23
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 15:22:24 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9e8522c10bso782247266b.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:22:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUflOgZ282R7Vu2KbNPvLh2kiuVmvf0xepoNo7dweD8nTxvb2HjzEZtgZhqVFDJMY9cK9Uj36v42wY=@vger.kernel.org
X-Received: by 2002:a17:907:9303:b0:a9a:eeb:b26a with SMTP id
 a640c23a62f3a-a9eefe42ca0mr1408722966b.1.1731367343376; Mon, 11 Nov 2024
 15:22:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731355931.git.josef@toxicpanda.com> <b509ec78c045d67d4d7e31976eba4b708b238b66.1731355931.git.josef@toxicpanda.com>
 <CAHk-=wh4BEjbfaO93hiZs3YXoNmV=YkWT4=OOhuxM3vD2S-1iA@mail.gmail.com> <CAEzrpqdtSAoS+p4i0EzWFr0Nrpw1Q2hphatV7Sk4VM49=L3kGw@mail.gmail.com>
In-Reply-To: <CAEzrpqdtSAoS+p4i0EzWFr0Nrpw1Q2hphatV7Sk4VM49=L3kGw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Nov 2024 15:22:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj8L=mtcRTi=NECHMGfZQgXOp_uix1YVh04fEmrKaMnXA@mail.gmail.com>
Message-ID: <CAHk-=wj8L=mtcRTi=NECHMGfZQgXOp_uix1YVh04fEmrKaMnXA@mail.gmail.com>
Subject: Re: [PATCH v6 06/17] fsnotify: generate pre-content permission event
 on open
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Nov 2024 at 14:46, Josef Bacik <josef@toxicpanda.com> wrote:
>
> Did you see the patch that added the
> fsnotify_file_has_pre_content_watches() thing?

No, because I had gotten to patch 6/11, and it added this open thing,
and there was no such thing in any of the patches before it.

It looks like you added FSNOTIFY_PRE_CONTENT_EVENTS in 11/17.

However, at no point does it look like you actually test it at open
time, so none of this seems to matter.

As far as I can see, even at the end of the series, you will call the
fsnotify hook at open time even if there are no content watches on the
file.

So apparently the fsnotify_file_has_pre_content_watches() is not
called when it should be, and when it *is* called, it's also doing
completely the wrong thing.

Look, for basic operations THAT DON'T CARE, you now added a function
call to fsnotify_file_has_pre_content_watches(), that function call
looks at inode->i_sb->s_iflags (doing two D$ accesses that shouldn't
be done!), and then after that looks at the i_fsnotify_mask.

THIS IS EXACTLY THE KIND OF GARBAGE I'M TALKING ABOUT.

This code has been written by somebody who NEVER EVER looked at
profiles. You're following chains of pointers when you never should.

Look, here's a very basic example of the kind of complete mis-design
I'm talking about:

 - we're doing a basic read() on a file that isn't being watched.

 - we want to maybe do read-ahead

 - the code does

        if (fsnotify_file_has_pre_content_watches(file))
                return fpin;

   to say that "don't do read-ahead".

Fine, I understand the concept. But keep in mind that the common case
is presumably that there are no content watches.

And even ignoring the "common case" issue, that's the one you want to
OPTIMIZE for. That's the case that matters for performance, because
clearly if there are content watches, you're going to go into "Go
Slow" mode anyway and not do pre-fetching. So even if content watches
are common on some load, they are clearly not the case you should do
performance optimization for.

With me so far?

So if THAT is the case that matters, then dammit, we shouldn't be
calling a function at all.

And when calling the function, we shouldn't start out with this
completely broken logic:

        struct inode *inode = file_inode(file);
        __u32 mnt_mask = real_mount(file->f_path.mnt)->mnt_fsnotify_mask;

        if (!(inode->i_sb->s_iflags & SB_I_ALLOW_HSM))
                return false;

that does random crap and looks up some "mount mask" and looks up the
superblock flags.

Why shouldn't we do this?

BECAUSE NONE OF THIS MATTERS IF THE FILE HASN'T EVEN BEEN MARKED FOR
CONTENT MATCHES!

See why I'm shouting? You're doing insane things, and you're doing
them for all the cases that DO NOT MATTER. You're doing all of this
for the common case that doesn't want to see that kind of mindless
overhead.

You literally check for the "do I even care" *last*, when you finally
do that fsnotify_object_watched() check that looks at the inode. But
by then you have already wasted all that time and effort, and
fsnotify_object_watched() is broken anyway, because it's stupidly
designed to require that mnt_mask that isn't needed if you have
properly marked each object individually.

So what *should* you have?

You should have had a per-file flag saying "Do I need to even call
this crud at all", and have it in a location where you don't need to
look at anything else.

And fsnotify already basically has that flag, except it's mis-designed
too. We have FMODE_NONOTIFY, which is the wrong way around (saying
"don't notify", when that should just be the *default*), and the
fsnotify layer uses it only to mark its own internal files so that it
doesn't get called recursively. So that flag that *looks* sane and is
in the right location is actually doing the wrong thing, because it's
dealing with a rare special case, not the important cases that
actually matter.

So all of this readahead logic - and all of the read and write hooks -
should be behind a simple "oh, this file doesn't have any notification
stuff, so don't bother calling any fsnotify functions".

So I think the pattern should be

    static inline bool fsnotify_file_has_pre_content_watches(struct file *file)
    {
        if (unlikely(file->f_mode & FMODE_NOTIFY))
                return out_of_line_crud(file);
        return false;
    }

so that the *only* thing that gets inlined is "does this file have any
fsnotify stuff at all", and in the common case where that isn't true,
we don't call any fsnotify functions, and we don't start looking at
inodes or superblocks or anything pointless like that.

THAT is the kind of code sequence we should have for unlikely cases.
Not the "call fsnotify code to check for something unlikely". Not
"look at file_inode(file)->i_sb->s_iflags" until it's *required*.

Similarly, the actual open-time code SHOULD NEVER BE CALLED, because
it should have the same kind of simple logic based on some simple flag
either in the dentry or maybe in the inode. So that all those *normal*
dentries and inodes that don't have watches don't get the overhead of
calling into fsnotify code.

Because yes, I do see all those function calls, and all those
unnecessary indirect pointer accesses when I do profiles. And if I see
fsnotify in my profiles when I don't have any notifications enabled,
that really really *annoys* me.

                 Linus

