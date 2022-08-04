Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7D3589A68
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Aug 2022 12:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiHDKZz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Aug 2022 06:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbiHDKZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 06:25:54 -0400
Received: from cczrelay02.in2p3.fr (cczrelay02.in2p3.fr [134.158.66.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADB063CD
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 03:25:51 -0700 (PDT)
Received: from cczmbox08.in2p3.fr (cczmbox08.in2p3.fr [134.158.66.138])
        by cczrelay02.in2p3.fr (8.14.4/8.14.4) with ESMTP id 274APWMc006516;
        Thu, 4 Aug 2022 12:25:32 +0200
Date:   Thu, 4 Aug 2022 12:25:31 +0200 (CEST)
From:   Emmanouil Vamvakopoulos <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
Reply-To: Emmanouil Vamvakopoulos 
          <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
To:     Dave Chinner <david@fromorbit.com>, ">" <cem@kernel.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <789765075.71120211.1659608731638.JavaMail.zimbra@ijclab.in2p3.fr>
In-Reply-To: <20220803215909.GC3600936@dread.disaster.area>
References: <1586129076.70820212.1659538177737.JavaMail.zimbra@ijclab.in2p3.fr> <1106593372.70825641.1659538603200.JavaMail.zimbra@ijclab.in2p3.fr> <20220803215909.GC3600936@dread.disaster.area>
Subject: Re: s_bmap and  flags explanation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [90.26.79.197]
X-Mailer: Zimbra 8.7.11_GA_3865 (ZimbraWebClient - FF103 (Mac)/8.7.11_GA_3865)
Thread-Topic: s_bmap and flags explanation
Thread-Index: bAeqFj3YQ/g7twH56SbpA/sdtUpEZw==
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

hello Carlos and Dave 

thank you for the replies

a) for the mismatch in alignment bewteen xfs  and underlying raid volume I have to re-check 
but from preliminary tests , when I mount the partition with a static allocsize ( e.g. allocsize=256k)
we have large file with large number of externs ( up to 40) but the sizes from du was comparable.

b) for the speculative preallocation beyond EOF of my files as I understood have to run xfs_fsr to get the space back. 

but why the inodes of those files remains dirty  at least for 300 sec  after the  closing of the file and lost the automatic removal of the preallocation ?

we are runing on CentOS Stream release 8 with 4.18.0-383.el8.x86_64 

but we never see something simliar on CentOS Linux release 7.9.2009 (Core) with  3.10.0-1160.45.1.el7.x86_64 
(for similar pattern of file sizes, but truly with different distributed strorage application)

thank you in advance
best
e.v.



----- Original Message -----
From: "Dave Chinner" <david@fromorbit.com>
To: "emmanouil vamvakopoulos" <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
Cc: "linux-xfs" <linux-xfs@vger.kernel.org>
Sent: Wednesday, 3 August, 2022 23:59:09
Subject: Re: s_bmap and  flags explanation

On Wed, Aug 03, 2022 at 04:56:43PM +0200, Emmanouil Vamvakopoulos wrote:
> 
> 
> Hello developers 
> 
> It is possible to explain the FLAGS field in xfs_bmap output of a file 
> 
>  EXT: FILE-OFFSET           BLOCK-RANGE              AG AG-OFFSET                 TOTAL FLAGS
>    0: [0..7]:               49700520968..49700520975 30 (8..15)                       8 001111
>    1: [8..4175871]:         49708756480..49712932343 30 (8235520..12411383)     4175864 000111
>    2: [4175872..19976191]:  49715788288..49731588607 30 (15267328..31067647)   15800320 000011
>    3: [19976192..25153535]: 49731588608..49736765951 30 (31067648..36244991)    5177344 000011
>    4: [25153536..41930743]: 49767625216..49784402423 30 (67104256..83881463)   16777208 000111
>    5: [41930744..58707951]: 49784402424..49801179631 30 (83881464..100658671)  16777208 001111
>    6: [58707952..58959935]: 49801179632..49801431615 30 (100658672..100910655)   251984 001111
>    7: [58959936..75485159]: 49801431616..49817956839 30 (100910656..117435879) 16525224 001111

$ man xfs_bmap
.....
       -v     Shows verbose information. When this flag is specified,
	      additional AG specific information is appended to each
	      line in the following form:

                   agno (startagoffset..endagoffset) nblocks flags

              A second -v option will print out the flags legend.
.....

So:

$ xfs_bmap -vvp foo
foo:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          440138672..440138679  4 (687024..687031)     8 000000
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width

And there's what the flags mean.

> with 
> 
> [disk06]# du -sh ./00000869/014886f4
> 36G	./00000869/014886f4
> [disk06]# du -sh --apparent-size  ./00000869/014886f4
> 29G	./00000869/014886f4
> 
> I try to understand if  this file contains unused externs 
> and how those file are created like this (if we assume that the free space was not fragmented ) 
> 
> we are running CentOS Stream release 8 with 4.18.0-383.el8.x86_64 
> 
> if I defrag the file above the difference bewteen apparent size and size with du disappered !

It will be a result of speculative preallocation beyond EOF as the
file is grown to ensure it doesn't get fragmented badly. Files in
the size range of tens of GB or larger will have preallocation
extend out to 8GB beyond EOF. It will get removed when the inode is
reclaimed from memory (i.e. no longer in active use).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
