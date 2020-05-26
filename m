Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967791B5E8C
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Apr 2020 17:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgDWPDP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Apr 2020 11:03:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47287 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728865AbgDWPDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 11:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587654194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=ytmDsBItU1XAiePCbYutVpeJ66G1by51D3lRkrPRGC8=;
        b=FoEDR9cxbdW9kPU0D6EbLK1HZAgH2J0J2XkTmr6US3rboD562o4sMKEx2DDSiHK1l6YrzP
        blaD9oHyJei7txkiQ/Cs8ousvkwK81FbZu5XbRxI3W39UGDnmUgMjw1dtdYLLp1UelrkJc
        UweF5H7buyueNb7GKXUhdVpEehnnz8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-GFjMt-EXMXKldzNpBh5NoQ-1; Thu, 23 Apr 2020 11:03:09 -0400
X-MC-Unique: GFjMt-EXMXKldzNpBh5NoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0590E461
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 15:03:09 +0000 (UTC)
Received: from redhat.com (ovpn-115-94.rdu2.redhat.com [10.10.115.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B29775C1C8
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 15:03:08 +0000 (UTC)
Date:   Thu, 23 Apr 2020 10:03:06 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [XFS SUMMIT] xfs and gcc
Message-ID: <20200423150306.GA345064@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello -

I'd be interested in having some discussion about the forward momentum
of gcc, and xfs staying in reasonable sync with it. I'm sure you've noticed
the warnings stacking up as xfs and xfsprogs is built. With gcc-10 coming
about in distros, the inevitable warnings and errors will become more than
annoying.

How best to approach modifications to xfs to alleviate these build issues?

Thanks-
Bill

