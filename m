Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32B73D197
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbfFKP7e (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:59:34 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36485 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727549AbfFKP7e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:59:34 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5BFxQKU021018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jun 2019 11:59:27 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0EA93420481; Tue, 11 Jun 2019 11:59:26 -0400 (EDT)
Date:   Tue, 11 Jun 2019 11:59:25 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Message-ID: <20190611155925.GA5081@mit.edu>
References: <20190611153916.13360-1-amir73il@gmail.com>
 <20190611153916.13360-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611153916.13360-2-amir73il@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 06:39:16PM +0300, Amir Goldstein wrote:
> Depending on filesystem, copying from active swapfile may be allowed,
> just as read from swapfile may be allowed.
> 
> Note the kernel fix commit in test description.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> 
> Per your and Ted's request, I've documented the kernel fix commit
> in the new copy_range tests. Those commits are now on Darrick's
> copy-file-range-fixes branch, which is on its way to linux-next
> and to kernel 5.3.

Thanks!  Are we sure at this point that the commit won't need to be
modified / rebased in Darrick's tree?

> +# This is a regression test for kernel commit:
> +#   a31713517dac ("vfs: introduce generic_file_rw_checks()")

					 - Ted
