Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42369367641
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Apr 2021 02:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhDVAaL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Apr 2021 20:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234856AbhDVAaL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 20:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C7816144A;
        Thu, 22 Apr 2021 00:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619051377;
        bh=9RxlfisS8r0GXdRoGr19KXekURwGI0pTG6Fch55aghA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EWgMuniilPYEpGob4gS5hO9zSUfkSZAa3TuhIGnSBw3i/RFE0b9k1bFQVjhUwQJ3b
         OnoJTpX2uHVWWf/zh/FRzsE8LCcMYDHOgyqnL1vp5i4yHKkFVnbNc29/9+h96VsBdm
         sHd/9nEs5oyVzIe3w63VIAZs4lCVFC1pTu01U8XN+kYzhMWsEiXzzfwL7GwIhheka4
         Mbn7kIZEkjHfJzlQoXzELr+fh0rOALjW3+xJSIbJMOcKu9Ygj9pIBmMEMNIzuRnjWh
         bibxVtkvsKR1Rkrg6wNWA424e+NnHxAqKPH2e91kd78zBdeFl1YG/Yt/8V9SdkusWI
         Bd8Vj4icJmASg==
Date:   Wed, 21 Apr 2021 17:29:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 3/7] xfs: pass a xfs_efi_log_item to xfs_efi_item_sizeof
Message-ID: <20210422002936.GA882213@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-4-hch@lst.de>
 <20210420170952.GI3122264@magnolia>
 <20210421055628.GB28961@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421055628.GB28961@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 07:56:28AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 20, 2021 at 10:09:52AM -0700, Darrick J. Wong wrote:
> > On Mon, Apr 19, 2021 at 10:28:00AM +0200, Christoph Hellwig wrote:
> > > xfs_efi_log_item only looks at the embedded xfs_efi_log_item structure,
> > > so pass that directly and rename the function to xfs_efi_log_item_sizeof.
> > > This allows using the helper in xlog_recover_efi_commit_pass2 as well.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_extfree_item.c | 15 +++++++--------
> > >  1 file changed, 7 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > > index ed8d0790908ea7..7ae570d1944590 100644
> > > --- a/fs/xfs/xfs_extfree_item.c
> > > +++ b/fs/xfs/xfs_extfree_item.c
> > > @@ -70,11 +70,11 @@ xfs_efi_release(
> > >   * structure.
> > >   */
> > >  static inline int
> > > -xfs_efi_item_sizeof(
> > > -	struct xfs_efi_log_item *efip)
> > > +xfs_efi_log_item_sizeof(
> > 
> > Shouldn't this be named xfs_efi_log_format_sizeof to correspond to the
> > name of the structure?  Two patches from now you (re)introduce
> > xfs_efi_item_sizeof that returns the size of a struct xfs_efi_log_item,
> > which is confusing.
> 
> Well, that was the main reason to move these out of place, as they are
> rather misnamed.

I agree with the motivation, but not the names you've picked.  I don't
like xfs_efi_log_item_sizeof /not/ being the sizing function for struct
xfs_efi_log_item, because (in my head anyway) XXX_sizeof should be the
function for struct XXX.

IOWs I think that in the end these two helpers should be:

static inline int
xfs_efi_log_format_sizeof(
	struct xfs_efi_log_format *elf)
{
	return sizeof(*elf) + elf->efi_nextents * sizeof(struct xfs_extent);
}

static inline int
xfs_efi_log_item_sizeof(unsigned int nextents)
{
	return sizeof(struct xfs_efi_log_item) + nextents * sizeof(struct xfs_extent);
}

--D
