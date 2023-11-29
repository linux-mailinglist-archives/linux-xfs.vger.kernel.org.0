Return-Path: <linux-xfs+bounces-267-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B02377FDC48
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 17:11:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6954828266C
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 16:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686E639AF7;
	Wed, 29 Nov 2023 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RCQDE7tQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD88CD67;
	Wed, 29 Nov 2023 08:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=At+baB7w4/cCPr227HUIIZ9SAVJqCXYSgDbYLq6yPe0=; b=RCQDE7tQoQcpcs23nH7cwY6Gqk
	9TAggBgvuVbCXvYPNIrEL9b0HHWMZiRjuGnarWU9Mnjxm4S9UqYoSjURBbqecnza9HIAj0uoobgAL
	TyqFD1JX4dxPu1Gz/hZ7posArSR3uMYC1DQgxvJuJnJwEXCz41Hv9/LjmKzU2lKMj3yNYCDSYUeTW
	YYVnVmmic9o3WaI/kGZOzZBlVZI1vuGk01XAZgNACYl1q6l3odKTUODhACs5emreHKV5YS/fK+TH1
	hUjPbkekjvzhYY6rFqwq0+DGFsHDnMH8GPaVdoWp6zqSSMQQsLcpmkEVoGNhsUzBBuNcm2J+4upUU
	Pc2uzSbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r8N9Q-00DYOd-SB; Wed, 29 Nov 2023 16:11:00 +0000
Date: Wed, 29 Nov 2023 16:11:00 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux XFS <linux-xfs@vger.kernel.org>,
	Linux Kernel Workflows <workflows@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Charles Han <hanchunchao@inspur.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH RESEND v2] Documentation: xfs: consolidate XFS docs into
 its own subdirectory
Message-ID: <ZWdilJHU2RqMwBUW@casper.infradead.org>
References: <20231128124522.28499-1-bagasdotme@gmail.com>
 <20231128163255.GV2766956@frogsfrogsfrogs>
 <20231129052400.GS4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129052400.GS4167244@frogsfrogsfrogs>

On Tue, Nov 28, 2023 at 09:24:00PM -0800, Darrick J. Wong wrote:
> Actually, ignore this suggestion.  I forgot that I have vim paths
> trained on the Documentation/filesystems/ directory, which means I'll
> lose the ability to
> 
> :f xfs-online-fsck-design.rst
> 
> and pop it open.  Not that I expect many more filesystems to grow online
> fsck capabilities, but you get the point...

Wouldn't you instead do:

:f xfs/online-fsck-design.rst

ie change one character (- to /)

