Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB87B250D
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Sep 2023 20:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjI1SPP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Sep 2023 14:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjI1SPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 14:15:13 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFADF1B3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 11:15:10 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5344d996bedso9268340a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 11:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1695924909; x=1696529709; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UoV8bp+GLn88RdeFyi+3G/jZGwWmlguHsi2KfbyyFTc=;
        b=FZWjL7rx6cimnbQUI4PXaa4SPW1ISCi/JYZbLMdTqJKMcXPqe4tG3f52cgreviNQLh
         CE3Oyl8TDqshOk9Fx1Y8bVXYRKxWpjV+mpXiXZVKJH3Z3GsfENFIgVKzk2Fwal1RtXJi
         L96rSNiFuFuJZGBAagapgbN75UU51spf7u/Q4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695924909; x=1696529709;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UoV8bp+GLn88RdeFyi+3G/jZGwWmlguHsi2KfbyyFTc=;
        b=vFRHhi//GdlqLPorZ+wZlEomkpXPO+4kLkozmKaFi0OEDysiDsiQ0hI3iwo3HstVvw
         mY6/bJPcHbQ5VUQZrMa6sjPM+Ewv7D2ANMa2ZSqUi4E1ikL1BDQiDgTnlC1b6xwhwi/G
         i6v/klfhRYRXTSqeG4PlE2aWXJpRzxeYlBR07T9h2zHg9batHrWa75/SwkU5tVsvNHYT
         V3KZQQguRnaRglXCgs/6HrSV5s9SYctnd2VOCNHzj0kkdaWMtHVbROB5iZXkXSaccRUy
         tqRZQnQf14JEquZM79iWUVPQSBx2L4Oq1vyowF8p+hQn4Ne0KmdStPMRpdAsYnHWUHUZ
         CrYw==
X-Gm-Message-State: AOJu0Yw5IwbsXJFaR0g2Sud0YRJW2Vdf3AFCpjRphfsL03wnpBCpzr+U
        b45ScXmTG9IOvkbbSWOjTOqrp4mE0tubBp4gDzJmarlP0Xg=
X-Google-Smtp-Source: AGHT+IGgHjytGw2lE8KvFNgSVWsLimNRl7WjKla78QpUqWLygizdcB5tY8xE3JGznmfvnSH7WjzEdw==
X-Received: by 2002:a05:6402:14ce:b0:533:87c9:4a81 with SMTP id f14-20020a05640214ce00b0053387c94a81mr1945289edx.29.1695924909270;
        Thu, 28 Sep 2023 11:15:09 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id i4-20020a50fc04000000b005254b41f507sm10041215edr.32.2023.09.28.11.15.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 11:15:08 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40572aeb73cso103099735e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 11:15:08 -0700 (PDT)
X-Received: by 2002:aa7:d899:0:b0:52f:c073:9c77 with SMTP id
 u25-20020aa7d899000000b0052fc0739c77mr1748627edq.35.1695922912868; Thu, 28
 Sep 2023 10:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-3-jlayton@kernel.org>
In-Reply-To: <20230928110554.34758-3-jlayton@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 Sep 2023 10:41:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wij_42Q9WHY898r-gugmT5c-1JJKRh3C+nTUd1hc1aeqQ@mail.gmail.com>
Message-ID: <CAHk-=wij_42Q9WHY898r-gugmT5c-1JJKRh3C+nTUd1hc1aeqQ@mail.gmail.com>
Subject: Re: [PATCH 87/87] fs: move i_blocks up a few places in struct inode
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Carlos Llamas <cmllamas@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Mattia Dongili <malattia@linux.it>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Brad Warrum <bwarrum@linux.ibm.com>,
        Ritu Agarwal <rituagar@linux.ibm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Mark Gross <markgross@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Sterba <dsterba@suse.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Ian Kent <raven@themaw.net>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Joel Becker <jlbec@evilplan.org>,
        Christoph Hellwig <hch@lst.de>,
        Nicolas Pitre <nico@fluxnic.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <huyue2@coolpad.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Jan Kara <jack@suse.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Christoph Hellwig <hch@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <muchun.song@linux.dev>, Jan Kara <jack@suse.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Dave Kleikamp <shaggy@kernel.org>, Tejun Heo <tj@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Neil Brown <neilb@suse.de>,
        Olga Kornievskaia <kolga@netapp.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Bob Copeland <me@bobcopeland.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Tony Luck <tony.luck@intel.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Anders Larsen <al@alarsen.net>,
        Steve French <sfrench@samba.org>,
        Paulo Alcantara <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Evgeniy Dushistov <dushistov@mail.ru>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, v9fs@lists.linux.dev,
        linux-afs@lists.infradead.org, autofs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev,
        linux-um@lists.infradead.org, linux-mtd@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
        linux-karma-devel@lists.sourceforge.net, devel@lists.orangefs.org,
        linux-unionfs@vger.kernel.org, linux-hardening@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        linux-trace-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 28 Sept 2023 at 04:06, Jeff Layton <jlayton@kernel.org> wrote:
>
> Move i_blocks up above the i_lock, which moves the new 4 byte hole to
> just after the timestamps, without changing the size of the structure.

I'm sure others have mentioned this, but 'struct inode' is marked with
__randomize_layout, so the actual layout may end up being very
different.

I'm personally not convinced the whole structure randomization is
worth it - it's easy enough to figure out for any distro kernel since
the seed has to be the same across machines for modules to work, so
even if the seed isn't "public", any layout is bound to be fairly
easily discoverable.

So the whole randomization only really works for private kernel
builds, and it adds this kind of pain where "optimizing" the structure
layout is kind of pointless depending on various options.

I certainly *hope* no distro enables that pointless thing, but it's a worry.

               Linus
