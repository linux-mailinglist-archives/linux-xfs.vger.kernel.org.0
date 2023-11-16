Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374987EDE25
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Nov 2023 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjKPKE1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Nov 2023 05:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjKPKE0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 05:04:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D1C189
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 02:04:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2F9C433C7;
        Thu, 16 Nov 2023 10:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700129062;
        bh=uIPRvuOccneeBtO3/9hRvyi7Ye1E1xX4yxPtxFdSS1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VJaExwT0OjsGuDC4xKVoWQ4hoI0j76mrFOPXoZGSAugFDHJpNWJqwS7jgnQjNlUCv
         JLKMQMoeEZngiMkm7GwxMsfBHV9PScoEcIqG/yMdmPmaSc35mWkErWIcpnK5IGVmbS
         4Cs6oBRCxCByuCoaqfqKnYOSgozuPI7L9t6EV/Ut1FGac5vgg5b06PH5IoxVVYTK+H
         XDPpWEZdDgYHhYSYGkLRdYcrWOhbJpEkW1oOZq7bnb1VkvmChIJR1GBxuUtR4Z/b4L
         I9lw/uH5yR4v2opFaSf8sEXM76PVtj5Jvnys/dqSZctxwTgbkE1agV0tZOY4Zl0bTj
         vqnNdeEUthPag==
Date:   Thu, 16 Nov 2023 11:04:16 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [xfsprogs PATCH] xfs_io/encrypt: support specifying crypto data
 unit size
Message-ID: <h7e7q6g7ti4mbre55ap6x5o6suzdiiyykxtn5pgfsf2w6y7esx@tg2qxsplx2zb>
References: <20231013062639.141468-1-ebiggers@kernel.org>
 <KMvmogj9a91wwFViEyqlFQPlIuusUrW4mllNMHHZWBgZzBLAzrSJ2c93ZZyLh7bh4tkBI-JTjQZ6LJrGHubXcQ==@protonmail.internalid>
 <20231116035846.GA1583@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116035846.GA1583@sol.localdomain>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 15, 2023 at 07:58:46PM -0800, Eric Biggers wrote:
> On Thu, Oct 12, 2023 at 11:26:39PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Add an '-s' option to the 'set_encpolicy' command of xfs_io to allow
> > exercising the log2_data_unit_size field that is being added to struct
> > fscrypt_policy_v2 (kernel patch:
> > https://lore.kernel.org/linux-fscrypt/20230925055451.59499-6-ebiggers@kernel.org).
> >
> > The xfs_io support is needed for xfstests
> > (https://lore.kernel.org/fstests/20231013061403.138425-1-ebiggers@kernel.org),
> > which currently relies on xfs_io to access the encryption ioctls.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  configure.ac          |  1 +
> >  include/builddefs.in  |  4 +++
> >  io/encrypt.c          | 72 ++++++++++++++++++++++++++++++++-----------
> >  m4/package_libcdev.m4 | 21 +++++++++++++
> >  man/man8/xfs_io.8     |  5 ++-
> >  5 files changed, 84 insertions(+), 19 deletions(-)
> 
> Hi!  Any feedback on this patch?

I've got a limited bandwidth these days, I'll try to review this sometime
around next week.

> 
> - Eric
