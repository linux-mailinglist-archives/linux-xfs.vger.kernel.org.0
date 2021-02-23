Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF8C3224EB
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 05:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhBWEdR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 23:33:17 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36642 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231202AbhBWEdQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 23:33:16 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E629410410B3;
        Tue, 23 Feb 2021 15:32:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEPNA-0005cn-P6; Tue, 23 Feb 2021 15:32:32 +1100
Date:   Tue, 23 Feb 2021 15:32:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: Skip repetitive warnings about mount options
Message-ID: <20210223043232.GT4662@dread.disaster.area>
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-3-preichl@redhat.com>
 <20210222212830.GE7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222212830.GE7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=tcWmSaC-cIDXloh973UA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 22, 2021 at 01:28:30PM -0800, Darrick J. Wong wrote:
> On Sat, Feb 20, 2021 at 11:15:49PM +0100, Pavel Reichl wrote:
> > Skip the warnings about mount option being deprecated if we are
> > remounting and deprecated option state is not changing.
> > 
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
> > Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 813be879a5e5..6724a7018d1f 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1169,6 +1169,13 @@ xfs_fs_parse_param(
> >  	struct fs_parse_result	result;
> >  	int			size = 0;
> >  	int			opt;
> > +	uint64_t                prev_m_flags = 0; /* Mount flags of prev. mount */
> 
> Nit: spaces here^^^^^^^^^^^^^^^^ should be tabs.
> 
> > +	bool			remounting = fc->purpose & FS_CONTEXT_FOR_RECONFIGURE;
> > +
> > +	/* if reconfiguring then get mount flags of previous flags */
> > +	if (remounting) {
> > +		prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;
> > +	}
> >  
> >  	opt = fs_parse(fc, xfs_fs_parameters, param, &result);
> >  	if (opt < 0)
> > @@ -1294,19 +1301,27 @@ xfs_fs_parse_param(
> >  #endif
> >  	/* Following mount options will be removed in September 2025 */
> >  	case Opt_ikeep:
> > -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> > +		if (!remounting ||  !(prev_m_flags & XFS_MOUNT_IKEEP)) {
> > +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> > +		}
> 
> /me wonders if these could be refactored into a common helper, though I
> can't really think of anything less clunky than:
> 
> static inline void
> xfs_fs_warn_deprecated(
> 	struct fs_context	*fc,
> 	struct fs_parameter	*param)
> 	uint64_t		flag,
> 	bool			value);
> {
> 	uint64_t		prev_m_flags;
> 
> 	if (!(fc->purpose & FS_CONTEXT_FOR_RECONFIGURE))
> 		goto warn;
> 	prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;
> 	if (!!(prev_m_flags & flag) == value)
> 		goto warn;
> 	return;
> warn:
> 	xfs_warn(mp, "%s mount option is deprecated.", param->key);
> }
> ...
> 	case Opt_ikeep:
> 		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
> 		mp->m_flags |= XFS_MOUNT_IKEEP;
> 		break;
> 	case Opt_noikeep:
> 		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, false);
> 		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> 		break;

	case Opt_ikeep:
		xfs_fs_warn_deprecated(fc, param,
				(mp->m_flags & XFS_MOUNT_IKEEP), true);
		mp->m_flags |= XFS_MOUNT_IKEEP;
		break;
	case Opt_noikeep:
		xfs_fs_warn_deprecated(fc, param,
				(mp->m_flags & XFS_MOUNT_IKEEP), false);
		mp->m_flags &= ~XFS_MOUNT_IKEEP;
		break;

static inline void
xfs_fs_warn_deprecated(
	struct fs_context	*fc,
	struct fs_parameter	*param)
	bool			old_value,
	bool			new_value);
{
	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
	    old_value == new_value)
		return;
	xfs_warn(mp, "%s mount option is deprecated.", param->key);
}

-Dave.

> 
> Thoughts?
> 
> --D
> 
> >  		mp->m_flags |= XFS_MOUNT_IKEEP;
> >  		return 0;
> >  	case Opt_noikeep:
> > -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> > +		if (!remounting || prev_m_flags & XFS_MOUNT_IKEEP) {
> > +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> > +		}
> >  		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> >  		return 0;
> >  	case Opt_attr2:
> > -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> > +		if (!remounting || !(prev_m_flags & XFS_MOUNT_ATTR2)) {
> > +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> > +		}
> >  		mp->m_flags |= XFS_MOUNT_ATTR2;
> >  		return 0;
> >  	case Opt_noattr2:
> > -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> > +		if (!remounting || !(prev_m_flags & XFS_MOUNT_NOATTR2)) {
> > +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> > +		}
> >  		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> >  		mp->m_flags |= XFS_MOUNT_NOATTR2;
> >  		return 0;
> > -- 
> > 2.29.2
> > 
> 

-- 
Dave Chinner
david@fromorbit.com
