Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5C57D46A2
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Oct 2023 06:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjJXELD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Oct 2023 00:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjJXEK7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 00:10:59 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4D8E9
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 21:10:55 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9c603e235d1so611427366b.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 21:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1698120654; x=1698725454; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R/DnLkXKcbtHeIdj2lNteiEcRFjQW0/FCeNT137Lkzs=;
        b=Aw95fEiSWtFcR8obn3vjO/5M5aj1EuPgR5uJJkCqlvJnxOXShvYCdyhamojVfrIQpi
         XDba13gNYmYGH0jiEeB8bDWs8chBIA8q/RfnAUFtqd+zRDiwEnVk235aoAUB8uQBnUNo
         +/9a+5m38Q6YGXKdQ3OdZcrhH1ryorDounMfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698120654; x=1698725454;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/DnLkXKcbtHeIdj2lNteiEcRFjQW0/FCeNT137Lkzs=;
        b=E/MTEfsbbh+D2UXRCuZ7Jum9R14EcqPrFJSOLf0GTYjf5UwubxDWNCbk1OBea34asC
         K5bZwnLToY8geg5cz+lWnxjCd6SRWLf5JSAtQ8hK1txUDOMj7UPOyc9H6h7aJO7ftzsr
         5Tt1Ka6lsxv/dT+OSgKF3nxgIkfgTPZhd/reiesIq0i5XlEhdKGszKG0VnS1r3RQfaMx
         o1yV6yoysu+zocRsSTU1yPlqU3Z/FjAdAkSPfvVnUAG3IZOa4M/t0fcRO1T0jHJOpvBJ
         SsMjB30j+KFpttZXQvyuztZKNnl2dvISKRO88r46YpSg7qcmz2BkPd5DkskUVQ9WKG93
         5geg==
X-Gm-Message-State: AOJu0YweOUVMLCcWD9amCTqWpBdqtxTM87YYydllpV/Lxi+CxSN5imb+
        sAlOcj67zRhLenrNP2vtzcrpIJhlpfLmyEOCGnmXZ1nN
X-Google-Smtp-Source: AGHT+IHGaSRZmXyMwhyBUXYWsSYGbqyKWhrOY8sRWLYv2hboLwTSaFLc+HgmP5ZPT5rwL2ma0HqPiQ==
X-Received: by 2002:a17:906:6a22:b0:9be:d15e:8ca2 with SMTP id qw34-20020a1709066a2200b009bed15e8ca2mr6622947ejc.39.1698120653959;
        Mon, 23 Oct 2023 21:10:53 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id f25-20020a170906561900b009920e9a3a73sm7617010ejq.115.2023.10.23.21.10.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 21:10:53 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-9c603e235d1so611426366b.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 21:10:53 -0700 (PDT)
X-Received: by 2002:a05:6402:274e:b0:53e:8e09:524d with SMTP id
 z14-20020a056402274e00b0053e8e09524dmr2329463edd.5.1698120632873; Mon, 23 Oct
 2023 21:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiKJgOg_3z21Sy9bu+3i_34S86r8fd6ngvJpZDwa-ww8Q@mail.gmail.com>
 <5f96e69d438ab96099bb67d16b77583c99911caa.camel@kernel.org>
 <20231019-fluor-skifahren-ec74ceb6c63e@brauner> <0a1a847af4372e62000b259e992850527f587205.camel@kernel.org>
 <ZTGncMVw19QVJzI6@dread.disaster.area> <eb3b9e71ee9c6d8e228b0927dec3ac9177b06ec6.camel@kernel.org>
 <ZTWfX3CqPy9yCddQ@dread.disaster.area> <61b32a4093948ae1ae8603688793f07de764430f.camel@kernel.org>
 <ZTcBI2xaZz1GdMjX@dread.disaster.area> <CAHk-=whphyjjLwDcEthOOFXXfgwGrtrMnW2iyjdQioV6YSMEPw@mail.gmail.com>
 <ZTc8tClCRkfX3kD7@dread.disaster.area>
In-Reply-To: <ZTc8tClCRkfX3kD7@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 23 Oct 2023 18:10:15 -1000
X-Gmail-Original-Message-ID: <CAHk-=wjUWM8VVJxUYb=XfqvrS38ACS8RxK2ac9qGp9FDT=USkw@mail.gmail.com>
Message-ID: <CAHk-=wjUWM8VVJxUYb=XfqvrS38ACS8RxK2ac9qGp9FDT=USkw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/9] timekeeping: new interfaces for multigrain
 timestamp handing
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John Stultz <jstultz@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.de>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 23 Oct 2023 at 17:40, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Maybe we don't even need a mode, and could just decide that atime
> > updates aren't i_version updates at all?
>
> We do that already - in memory atime updates don't bump i_version at
> all. The issue is the rare persistent atime update requests that
> still happen - they are the ones that trigger an i_version bump on
> XFS, and one of the relatime heuristics tickle this specific issue.

Yes, yes, but that's what I kind of allude to - maybe people still
want the on-disk atime updates, but do they actually want the
i_version updates just because they want more aggressive atime
updates?

> > Or maybe i_version can update, but callers of getattr() could have two
> > bits for that STATX_CHANGE_COOKIE, one for "I care about atime" and
> > one for others, and we'd pass that down to inode_query_version, and
> > we'd have a I_VERSION_QUERIED and a I_VERSION_QUERIED_STRICT, and the
> > "I care about atime" case ould set the strict one.
>
> This makes correct behaviour reliant on the applicaiton using the
> query mechanism correctly. I have my doubts that userspace
> developers will be able to understand the subtle difference between
> the two options and always choose correctly....

I don't think we _have_ a user space interface.

At least the STATX_CHANGE_COOKIE bit isn't exposed to user space at
all. Not in the uapi headers, but not even in xstat():

        /* STATX_CHANGE_COOKIE is kernel-only for now */
        tmp.stx_mask = stat->result_mask & ~STATX_CHANGE_COOKIE;

So the *only* users of STATX_CHANGE_COOKIE seem to be entirely
in-kernel, unless there is something I'm missing where somebody uses
i_version through some other interface (random ioctl?).

End result: splitting STATX_CHANGE_COOKIE into a "I don't care about
atime" and a "give me all change events" shouldn't possibly break
anything that I can see.

The only other uses of inode_query_iversion() seem to be the explicit
directory optimizations (ie the "I'm caching the offset and don't want
to re-check that it's valid unless required, so give me the inode
version for the directory as a way to decide if I need to re-check"
thing).

And those *definitely* don't want i_version updates on any atime updates.

There might be some other use of inode_query_iversion() that I missed,
of course.  But from a quick look, it really looks to me like we can
relax our i_version updates.

              Linus
