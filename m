Return-Path: <linux-xfs+bounces-25031-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84118B3863B
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Aug 2025 17:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB4037B8034
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Aug 2025 15:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCFD27A904;
	Wed, 27 Aug 2025 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QdO2d/7q"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DC027979F
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 15:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307764; cv=none; b=DzhXfggcSed+VRiddOqMwtAmAj39I0TiPfeRuAz5Xsg5tRNL/C0pQd4gvCsheA8PznOrQAGBJ9oUoj7lFYl0qA9fSDHVi183bkRNx8xX35Ew3oCBNyCScYrDGLVDNRg9JYZOx1JZ9i7d8zWzZ+uAUxmihoesDY1cuwrWW2vVLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307764; c=relaxed/simple;
	bh=rzC+AAKCUl6vzJu+zwRiqngc9S4GXWBpQ7VnSGeen5s=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 In-Reply-To:To:Cc; b=A5D3RmMjTKP+WA1RSO+0fO54ywBSKOSEIXeQHsPWuwKgGIuefxmJ4KMbs/s3UmJLGb3oQknpDrs6eZspeme+6HfiWA2jw222/o+ikuT1nS2wRCb9qsejHYzmRY36cEDA3vgKyKAocgXqkaBNDCdefJ359z3efDXt3rqWQPzSCoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QdO2d/7q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756307761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=B9Y3x/GHndHIs7kj57pNCjaMryyI+bnoj8pwk8ELUPU=;
	b=QdO2d/7qJQof0QsvUgU+k5lirvk7enfBIgnPL7YNqCkQJf86PB/+18QQfM8mqyYbkM148L
	ne3PBP9dfLm2Xkt7ZU03S++dX8Fi5V2J0LfkiqgzcFoo4CQqXG3vZfHGyaU4AF5o/mmhLM
	R4zDBAwK3kPNsj4ahLAtoABIRoR7RKs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-c77NXm5DOvC6FKG9Mup0RA-1; Wed, 27 Aug 2025 11:15:59 -0400
X-MC-Unique: c77NXm5DOvC6FKG9Mup0RA-1
X-Mimecast-MFC-AGG-ID: c77NXm5DOvC6FKG9Mup0RA_1756307758
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0ccb6cso34361655e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 08:15:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307757; x=1756912557;
        h=cc:to:in-reply-to:content-transfer-encoding:mime-version:message-id
         :date:subject:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B9Y3x/GHndHIs7kj57pNCjaMryyI+bnoj8pwk8ELUPU=;
        b=k8b0Xt28fz0U54vGZz/YckkOdihWp/MFs+5wIO13eWSxwPNaQIjIEkphFVwKKB9k4i
         LN8eoRpTsiO43Wt2hQqMQxSWxGSLbfa6H61ixyPhUyZsHqBIXXJ1yCf37aa6EW+iJbxm
         AM1BtzUYMeTzu4ogUaYW0DSsYqfzXxMKutu58tDjJh5ZRqVnRpylAn5KttNZRJWxD7x9
         SoZ83FtCJJEtC2U8WpVErMHQLaRArgD8+y94NsXqqnNhnKOjHa153WnH/D1FQmRwNkTD
         443RVUtzKZ6xQFhEubFzBW2w+l3kDV0bM4/6EN6BTPoP6wN1tq/aAE69TfB7arDaRJ/e
         jK+g==
X-Forwarded-Encrypted: i=1; AJvYcCVdE9QvGl2BN2X+c8PnR2FMtoyzCT4yMYrX9WFVsL/XzPz5/FsVFkORWwr3gX/SINQB9/DUou35vAY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbSoYg1En4yeariDqLmH0rh2rek6DM0MfF0Eb9eOKNiIYbJ46/
	UQyXBN3Er7Ozbv7fDsZ/LcWUIz2Sm4prXsxxbvcG4XGUGYwQx7PpovqDR2Hk8L+MgUcLmqwdv5H
	mtlE4jRpwxdu7hA1iWxIszhYnEGMYgUHfqhlGHWVRUX4QtqHxiCupgz2KvvOtpxs08LZ2
X-Gm-Gg: ASbGncscYEeG+cMABcJqNq1svMi3aidlRgBZ8nHPH/qhZev18O1X2NSFolDsKmqbfub
	YLBrWbpa+KZuK0DSaNaLmvm+WGCw/49Z3M/7X3I8Te5tf/llrdqVe8gdW/TT3diizxz+A1ZX//A
	AtyZe0dLfbJbdaDizgqmmieK7RcYt8Ch2MOemUUT6ttTWvQc75ivN3KT4T34jnNTd3ZqweuSBLq
	SxJhW0LJXcUiZez/6bo3UB88UEpW0KGSH3JoulvQF0mGFi1toP5yWhgxYT94DQTslhWoj7fEGwR
	BGqWTKeDxkEp/pT0Iw==
X-Received: by 2002:a05:600c:1c9d:b0:45b:6684:9e07 with SMTP id 5b1f17b1804b1-45b685d740emr46789875e9.32.1756307757591;
        Wed, 27 Aug 2025 08:15:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA5DHIbOsOGXO44yhdKhdwSRpScKdRyBp/ZCADkVRLFJ3dOz/cnKoO7Mh+/XAjwkYYvzpbIQ==
X-Received: by 2002:a05:600c:1c9d:b0:45b:6684:9e07 with SMTP id 5b1f17b1804b1-45b685d740emr46789705e9.32.1756307757221;
        Wed, 27 Aug 2025 08:15:57 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0e27b2sm33896285e9.10.2025.08.27.08.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 08:15:56 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v2 0/4] xfsprogs: utilize file_getattr() and file_setattr()
Date: Wed, 27 Aug 2025 17:15:52 +0200
Message-Id: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACghr2gC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDI1MDY0Nz3YrEkpKixBLd4sri5MScHF0LY8u0JKOkJINkM2MloK6CotS0zAq
 widGxtbUAPLGh/2EAAAA=
X-Change-ID: 20250317-xattrat-syscall-839fb2bb0c63
In-Reply-To: <dvht4j3ipg74c2inz33n6azo65sebhhag5odh7535hfssamxfa@6wr2m4niilye>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1469; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=rzC+AAKCUl6vzJu+zwRiqngc9S4GXWBpQ7VnSGeen5s=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtYr6lSs46iU9nG/3X3TYLbZcgXWJ1e0TgaJbObY8
 Cz0wfR/JY87SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATOSDCsM/A8uJnOUa+y33
 x+XaiNRrnWM8ZbJ2Su2thcli+56KPvsox/BXdopp7L/3rL6ZLJ0bl254ufWynKr2+q0yT9euv/7
 kTfESFgCu7Ug1
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Hi all,

This patchset updates libfrog, xfs_db, xfs_quota to use recently
introduced syscalls file_getattr()/file_setattr().

I haven't replaced all the calls to ioctls() with a syscalls, just a few
places where syscalls are necessary. If there's more places it would be
suitable to update, let me know.

Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

---
Andrey Albershteyn (4):
      libfrog: add wrappers for file_getattr/file_setattr syscalls
      xfs_quota: utilize file_setattr to set prjid on special files
      xfs_io: make ls/chattr work with special files
      xfs_db: use file_setattr to copy attributes on special files with rdump

 configure.ac          |   1 +
 db/rdump.c            |  20 ++++++-
 include/builddefs.in  |   5 ++
 include/linux.h       |  20 +++++++
 io/attr.c             | 138 ++++++++++++++++++++++++++++--------------------
 io/io.h               |   2 +-
 io/stat.c             |   2 +-
 libfrog/Makefile      |   2 +
 libfrog/file_attr.c   | 122 +++++++++++++++++++++++++++++++++++++++++++
 libfrog/file_attr.h   |  35 +++++++++++++
 m4/package_libcdev.m4 |  19 +++++++
 quota/project.c       | 142 ++++++++++++++++++++++++++------------------------
 12 files changed, 381 insertions(+), 127 deletions(-)
---
base-commit: 1d287f3d958ebc425275d6a08ad6977e13e52fac
change-id: 20250317-xattrat-syscall-839fb2bb0c63

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>


