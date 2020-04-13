Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B61A6CA6
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Apr 2020 21:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388001AbgDMTkk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Apr 2020 15:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387995AbgDMTkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Apr 2020 15:40:37 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771D7C008749
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 12:40:35 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b18so1119709ilf.2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 12:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=juliacomputing-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bdK8gEyBj47+B+b5fdWD48DFf9snz/SocRpKyG/PMKw=;
        b=1x8U2KZMxLh/Y782kba7SyBXt1QFaYYGloH3M3XRqPHvjiH2sJChN66jW+0oFeYTho
         U3L1FYkAiqUREN247XRMF+D9yNlFBFCwnvXrstKNfnLkFZgulF1vt3r9u3ewQnRRdlX1
         ZM/jrhK7ZZkhAAQoeg5QtMZesveYglPTsh7Q+RqGlSxHkvA6V3plAF0jBUQbY9NtCwas
         Y+Px8gK2IVOkpFQ3xiy5g8ywMA2Zt4DKXaeRoYg2yyG/nXnRDqNCE87GJG9j/1C10x5Z
         MfkMxvvdM71yjDwaY0nbxX+Yd5JaG3w//3ZXeQNKiX2QRcF8Ml5y9h6WpbuMziJnx9vQ
         bOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bdK8gEyBj47+B+b5fdWD48DFf9snz/SocRpKyG/PMKw=;
        b=mhHVkHomgXXHq9RoZyih30MEw1+zTN9/2om6yx+VzJvY4aJUX1nB6DSa88SCPTGdnH
         bG+icsRa2LPgEfwQcHRMdR7qo4AD4ByzQG+IEPyRvj7M0azA+z8omguZRidAfXc2SCY0
         SRI0VxZxeVK3EzeqeiTfU9gp95yqZvekxQngqlcH4QV5MUcjeK/tjXphNo8mvRXobhLc
         g4cn0/L0JHFAgWD42rbLW+FNblbqaEY9pYnPK4OHlT6ctaIFtJlsPM/sGPBdDRDUDorB
         4iErTJQprJwUpTMVTC0MSGGNws70ULMhHVYc61dZ7587toioxs4gZQLgTfHiindSZVop
         K8Cw==
X-Gm-Message-State: AGi0PuZdBGUjiiLMekUYqfOdf1zwb6CpjhrTH0odYTVbFPrOp/h9YRGP
        fgZcGo2/IOQVhDT/Y506ulg37firaAE/4UqTzXU9Fg==
X-Google-Smtp-Source: APiQypIknUBY7zD49Gd1oPk5pW7D4JYc6dZ50SjzIyGXfthayjGIWZ1Eh2CgEOvbLhUjF/axckqco/b7Gsb8b6IyFfM=
X-Received: by 2002:a92:5f17:: with SMTP id t23mr4857115ilb.2.1586806834685;
 Mon, 13 Apr 2020 12:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <CABV8kRw_jGxPqWc68Bj-uP_hSrKO0MmShOmtuzGQA2W3WHyCrg@mail.gmail.com>
 <CAOQ4uxhPKR34cXvWfF49z8mTGJm+oP2ibfohsXNdY7tXaOi4RA@mail.gmail.com>
 <CABV8kRxVA0j2qLkyWx+vULh2DxK2Ef4nPk-zXCikN8XmdBOFgQ@mail.gmail.com> <CAOQ4uxh2KKwORLC+gWEF=mWzBa3Kh4A4HgRoiad5N5qu06xjcg@mail.gmail.com>
In-Reply-To: <CAOQ4uxh2KKwORLC+gWEF=mWzBa3Kh4A4HgRoiad5N5qu06xjcg@mail.gmail.com>
From:   Keno Fischer <keno@juliacomputing.com>
Date:   Mon, 13 Apr 2020 15:39:58 -0400
Message-ID: <CABV8kRxsGm2-RLsuWPQGc82=6+x8v8FtV0=a6MQS=Nt-Pv3V9A@mail.gmail.com>
Subject: Re: Same mountpoint restriction in FICLONE ioctls
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Olga Kornievskaia <kolga@netapp.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> You make it sound like the heuristic decision must be made
> *after* trying to clone, but it can be made before and pass
> flags to the kernel whether or to fallback to copy.

True, though I simplified slightly. There's other things we try
first if the clone fails, like creating a hardlink. If cloning fails,
we also often only want to copy a part of the file (again
heuristically, whether more than what the program asked
for will be useful for debugging)

> copy_file_range(2) has an unused flags argument.
> Adding support for flags like:
> COPY_FILE_RANGE_BY_FS
> COPY_FILE_RANGE_BY_KERNEL

That would solve it of course, and I'd be happy with that
solution, but it seems like we'd end up with just another
spelling for the cloning ioctls then that have subtly different
semantics.

> I can also suggest a workaround for you.
> If your only problem is bind mounts and if recorder is a privileged
> process (CAP_DAC_READ_SEARCH) then you can use a "master"
> bind mount to perform all clone operations on.
> Use name_to_handle_at(2) to get sb file handle of source file.
> Use open_by_handle_at(2) to get an open file descriptor of the source
> file under the "master" bind mount.

Thanks, that's a very valuable suggestion - I hadn't considered
that. Unfortunately, I don't think the recorder does generally have
those privileges. It doesn't help in my use case, since I'm recording
a container that makes use of user namespaces, so nothing requires
priviledge, but it does seem like it would be useful if the recorder does
have appropriate capabilities (rr already has a mode where it runs
with privilege, e.g. for recording setuid binaries).

Keno
