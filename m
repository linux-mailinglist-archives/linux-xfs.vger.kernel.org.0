Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCC3558AE0
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Jun 2022 23:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiFWVkd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Jun 2022 17:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWVkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 17:40:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D27253A69;
        Thu, 23 Jun 2022 14:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cp1xyTMzLUHADTviQnt3oX0Sma33cYvTDD/dTuC+dO8=; b=dl77+AzjYjwwjw9kI28TqUvuPr
        0Cr+wYgw3qUsRP+6AZbi4DWGbc0q1uQxCIwAkQ+tIDP6fYf1MPVxEzrfidJYofGWMXPFtIQlgO3xH
        /D2iJhHnym/ita4D3zOlLqBKQYhNqg3dxrxUcERh/mKOvLBRt6ZATxGDgc64FajiZBly7Pv5LGnND
        VU/loElAPD+3kmDxcFN62gY5oabIxkgaV+nSfrxB1CNJ/sW6NAcbBivAgLAlYtcb23TZFQIZRNU9g
        kzYhWGzONELPJpaVXmksRr2zqQNhGkP/+TW+YwbHaSxS33eC+/J0QSSVsSwwqPwhY717fK7Xql/rP
        aPAdlpIA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4UYv-00GsfV-Ph; Thu, 23 Jun 2022 21:40:29 +0000
Date:   Thu, 23 Jun 2022 14:40:29 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>, linux-xfs@vger.kernel.org,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrTdzSkubXtQDFjj@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrOPEnO8hufMiRMi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrOPEnO8hufMiRMi@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 02:52:18PM -0700, Leah Rumancik wrote:
> On Tue, Jun 21, 2022 at 05:07:10PM -0700, Luis Chamberlain wrote:
> > On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> > > https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 
> > 
> > The coverage for XFS is using profiles which seem to come inspired
> > by ext4's different mkfs configurations.
> The configs I am using for the backports testing were developed with
> Darrick's help.

Sorry for the noise then.

> If you guys agree on a different set of configs, I'd be
> happy to update my configs moving forward.

Indeed it would be great to unify on target test configs at the very least.

  Luis
